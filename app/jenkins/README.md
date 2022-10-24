Information for https://youtu.be/ZXaorni-icg
https://gist.github.com/darinpope/67c297b3ccc04c17991b22e1422df45a

# jenkins-config.yaml
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "192.168.1.19"
  apiServerPort: 58350
```

# Commands for kind cluster

* `kind create cluster --config jenkins-config.yaml`
* `kubectl cluster-info --context kind-kind`
* `kubectl create namespace jenkins`
* `kubectl create serviceaccount jenkins --namespace=jenkins`
* `kubectl describe secret $(kubectl describe serviceaccount jenkins --namespace=jenkins | grep Token | awk '{print $2}') --namespace=jenkins`
* `kubectl create rolebinding jenkins-admin-binding --clusterrole=admin --serviceaccount=jenkins:jenkins --namespace=jenkins`



# Pipeline version 1
```
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
        '''
    }
  }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
      }
    }
  }
}
```

# Pipeline version 2
```
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: node
            image: node:16-alpine3.12
            command:
            - cat
            tty: true
        '''
    }
  }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
        container('node') {
          sh 'npm version'
        }
      }
    }
  }
}
```

# Pipeline version 3
```
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: node
            image: node:16-alpine3.12
            command:
            - cat
            tty: true
        '''
    }
  }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
          sh ' echo Hello World > hello.txt'
          sh 'ls -last'
        }
        container('node') {
          sh 'npm version'
          sh 'cat hello.txt'
          sh 'ls -last'
        }
      }
    }
  }
}
```

# Pipeline version TF

```
pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: terraform
            image: hashicorp/terraform:latest
            command:
            - cat
            tty: true
        '''
    }
  }
  stages {
    stage('TF Get Code') {
      steps {
        container('terraform') {
        echo 'TF File'
        sh """
          cat > main.tf << EOF
          resource "local_file" "demo_local_file" {
            content  = "Hello terraform local!"
            filename = "${path.module}/demo_local_file.txt"
          }
          EOF
        """.stripIndent()
        }
      }
    }
    stage('TF init') {
      steps {
        container('terraform') {
          sh 'terraform init'
        }
      }
    }
    stage('TF plan') {
      steps {
        container('terraform') {
          sh 'terraform plan'
        }
      }
    }
    stage('TF apply') {
      steps {
        container('terraform') {
          sh 'terraform apply'
        }
      }
    }
    stage('TF test') {
      steps {
        container('terraform') {
          sh 'cat demo_local_file.txt'
        }
      }
    }
  }
}

```

