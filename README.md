# aws-sso-cred

A CLI tool to switch one of your AWS SSO profiles as the default profile.

## Installation AWS CLI v2

To install the AWS CLI v2, run the `install` script:

```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip

$ ./install -i ~/.local/aws-cli -b ~/.local/bin
```

This will install the AWS CLI v2 in `~/.local/aws-cli` and create
symlinks for `aws` and `aws_completer` in `~/.local/bin`. For more
information about these options, run the `install` script with `-h`:

```
$ ./install -h
```

Assuming `~/.local/bin` is on your `PATH`, you can now run:

```
$ aws --version
```

## Configure your profiles with the `aws configure sso` wizard

```
$ aws configure sso
SSO session name (Recommended): my-sso
SSO start URL [None]: https://my-sso-portal.awsapps.com/start
SSO region [None]: us-east-1
SSO registration scopes [None]: sso:account:access
```

Do each for your profiles, then check your AWS config by `cat ~/.aws/config`

```
$ cat ~/.aws/config

[profile dev]
sso_session = sso
sso_account_id = 987654321098
sso_role_name = Dev
region = us-west-2
output = json

[sso-session sso]
sso_start_url = https://d-283763dbc8.awsapps.com/start/#/
sso_region = us-west-2
sso_registration_scopes = sso:account:access

[profile prod]
sso_session = sso
sso_account_id = 987654321097
sso_role_name = Production
region = us-west-2
output = json

[profile ops]
sso_session = sso
sso_account_id = 987654321096
sso_role_name = OPS_ReadOnlyAccess
region = us-west-2
output = json
```

## Switch your profile as the default profile by `npx aws-sso-cred <profile-name>`

```
# Login with any profile
aws sso login --profile ops

# Set profile dev as default profile
npx aws-sso-cred dev

# Set profile ops as default profile
npx aws-sso-cred ops

# Set profile prod as default profile
npx aws-sso-cred prod

```
