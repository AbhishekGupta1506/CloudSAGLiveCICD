pipeline{
    agent{
        node{
            label 'DesignerWin'
            customWorkspace 'C:/CloudTransformation/SAGLiveWorkspace'
            }
        }
    stages{
        stage('CheckOut'){
            parallel{
                    stage('CheckOut Assets'){
                        steps{
                            script{
                                if (!fileExists('Assets')) {
                                bat 'mkdir Assets'
                                echo 'Assets directory created under ${customWorkspace}'
                            } else {
                                echo 'Assets directory exist'
                            }
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets'){                               
                                bat 'git clone --recurse-submodules https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                            }
                            }                                                        
                            }
                    }

                }
        }        
    }
}