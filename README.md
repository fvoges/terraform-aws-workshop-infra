# AWS classroom infra


## Using the outputs

### Get the list of commands to connect using VS Code CLI tool

```shell
terraform output -json user_credentials|jq -r '.[] | "code --remote ssh-remote+" +  .user + "@" + .host +" /home/" + .user'
```
