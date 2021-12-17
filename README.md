The presentation for this talk can be found at: https://app.excalidraw.com/l/1bhFY0Jtn8S/1xUSklpI5aj

Video of this talk can be found at: https://youtu.be/xyuXM6HARfM

Go to root folder and provision the virtual machines
`vagrant up --provision`

The following codes have to run inside the corresponding virtual machines running the service.
Get list of VM's by running `vagrant status` and SSH into each one when running the commands

VAULT: Launch script
```
# Launch vault server in dev mode and set environment variables
vault server -dev -dev-listen-address=192.168.56.3:8200 &

export VAULT_ADDR=http://192.168.56.3:8200
export VAULT_TOKEN=$(cat .vault-token)
```

In Vault UI, login with the token given in previous code block and enable kv engine and fetch some secrets.
In this example I created kv engine called "kv" and stored the secrets in path "postgres"

VAULT: Getting vault secrets
```
vault kv get kv/postgres
vault kv get -format=json kv/postgres
```


VAULT: Enable one time users for postgres

Enable a database engine from Vault UI
For the sake of this tutorial, name the Database engine "postgres"
Next click "Create connection"
Select "PostgreSQL" as the Database plugin
Name the connection "postgres"
For Connection URL give following value (psql1 private ip): postgresql://postgres:postgres@192.168.56.4:5432/postgres
For root user and password give values "postgres"
Click "Create database" > "Enable without rotating"

Click "Add role"
For the sake of this tutorial, lets name this Role as "service"
Select "Dynamic" as the Type of role
For creation statements add: CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; , click add
Add a second row: GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}"; , click add
Click "Create role"

To try this out, you can click "Generate credentials" from the UI and use the generated credentials to connect into psql1
```
psql -h 192.168.56.4 -p 5432 -U <generated-username> -W postgres
```

Now let's run up boundary controller and worker

BOUNDARY:
```
# Note that the database for Boundary was already initialized by Vagrant, see the `provision/install_boundary.sh`
boundary server -config /provision/boundary.hcl &
# You can find Boundary UI from 192.168.56.2:9200
# Login username is admin and password can be found with the next command

cat /media/boundary_init_db.txt | grep -A7 "Initial auth information:"

export BOUNDARY_ADDR=http://192.168.56.2:9200/
export BOUNDARY_TOKEN=<replace with value from the cat command above>
```

BOUNDARY WORKER: Setting up boundaryworker
```
sudo boundary server -config /provision/boundary-worker.hcl
```

In Boundary UI click on "Auth methods" and copy the ID to the boundary command below
```
boundary authenticate password -auth-method-id <auth_method_id> -login-name admin -password "<BOUNDARY_TOKEN>" -keyring-type=none
boundary authenticate password -auth-method-id ampw_2VbImhUmmT -login-name admin -password "6H0WCGZWftvLUfr3h9ZW" -keyring-type=none

You will be greeted with following output, you can save it to use the token later.
Authentication information:
  Account ID:      acctpw_vj4IosBk1b
  Auth Method ID:  ampw_2VbImhUmmT
  Expiration Time: Fri, 24 Dec 2021 14:41:19 UTC
  User ID:         u_NHrRcbdumI

Storing the token in a keyring was disabled. The token is:
at_ep6x7K32uy_s14YkAS2cKMSt4cFqe34d9oeK1564Zurm2nS2k8ScdrvkskGmv8a1WCrwJxeQR3gWSLAvuVwKi7UT9iChfd9ad45DE67sN8cqrqjNW5TH5Dn3nMt51cTzHBTDcUDHehguMvHS
Please be sure to store it safely!
```

Use the above token to run the commands in the future:
```
export BOUNDARY_ADDR=http://192.168.56.2:9200
export BOUNDARY_TOKEN=<token from above>
```

Setting Boundary infra
- Create organization
- Create Project
- Create host catalog
- Create host set
- Create host 192.168.56.4 - NOTE that you cant have multiple hosts in a host set
- Create target Default port 5432 (psql) - Remember to add host source for target

Try out the connection and connect to postgres through boundary
```
boundary connect postgres -target-id <target-id> of your newly created target> -dbname postgres -username postgres
```

Setting Vault/Boundary connection:
- Create credential store - For connection store you will need to create new vault token that has boundary policies and  is not connected to an user (see code below)
- Create credential library
- Add credential library to target

VAULT: (go to Vault UI and create new policy called 'boundary' and copy the policy json from `vault_policies/boundary.hcl`)
```
vault auth enable userpass

vault write auth/userpass/users/hug \
    password=hug \
    policies=boundary

vault login -method=userpass \
    username=hug \
    password=hug
# Vault create token
vault token create -orphan -period "72h" -renewable -policy "boundary"
```
Use the token generated from the last command on the boundary UI credential store configuration

Once the credential store is configured you need to create a Credential library inside the credential store
Name it how you will but set the Vault path parameter to postgres/creds/service"
Hit Save and go to your target and connect this new credential library to your target

Now you should be able to connect with the following commands. Make sure you have the proper environment variables
set on the machine you decide to use
```
boundary targets authorize-session -id <target_id> -format json | jq '.'
boundary connect postgres -target-id <target_id> -dbname postgres
```
