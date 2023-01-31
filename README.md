# Triangle Classification API

author: Karlos Helton Braga


## About the project

The project is based on the creation of a native API to evaluate triangles in **Python** (**FastAPI**), returning its type. The project structure was created using **Terraform** for **AWS** Infra as Code, it was created **CloudWatch** Logs (different streams for `succededs` and `errors`) and **MySQL** database using **RDS**. As well as using **Docker** and **Docker Compose**, to create one machine for the API.

Due to the use of many complex commands, **Make** has been included for ease of use. 


## Project Execution

After clonning the project, go to the env folder and duplicate the example files (`example.env`, `example.tfvars`) and rename then to dev files (`dev.env`, `dev.tfvars`). Then put the values required.

Use the following commands to run the entire project structure:

```
make cloud-start
```

```
make build
```

```
make start
```

The command to enter the API machine terminal:

```
make api-bash
```

The command to view the API machine error logs:

```
make api-print-logs
```

The commands to stop the project:

```
make finish
```

```
make cloud-finish
```


## The API

The API address depends on the IP of the docker machine. Usually, docker runs the machine at the IP `127.0.0.1` or `localhost`. The API port is 8000 and its main endpoint is `api/triangles`.

In this case, the final API address is: 

http://127.0.0.1:8000/api/triangles


## Automated Tests

The automatic tests were made using **Pytest** and in the **TDD** format.

The command to run the API unit tests:

```
make test-api
```


## Test Post Script
A .sh script was created to manually test the input values on the 3 sides of the triangle.

At the terminal,the command to run the script:

```
./test_post_url.sh
```


## API Description

The **FastAPI** framework provides automatic documentation from the created endpoints. It shows the default endpoints (GET, POST, etc) and Schemas, these being the request and response formats.

Documentation is available at this url:

http://127.0.0.1:8000/docs

It is necessary to remember the need to have the project running in order to access this address.
