Para criar as tabelas no banco de dados MongoDB com as especificações mencionadas, siga os passos abaixo:

Passo 1: Instalação do MongoDB no Linux
1. Abra o terminal do seu sistema Linux.
2. Adicione a chave de assinatura do repositório oficial do MongoDB:
   ```
   wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
   ```
3. Adicione o repositório oficial do MongoDB ao seu sistema:
   ```
   echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
   ```
4. Atualize a lista de pacotes disponíveis:
   ```
   sudo apt-get update
   ```
5. Instale o MongoDB:
   ```
   sudo apt-get install -y mongodb-org
   ```

Passo 2: Configuração do MongoDB
1. Abra o arquivo de configuração do MongoDB usando um editor de texto:
   ```
   sudo nano /etc/mongod.conf
   ```
2. Localize a seção `security` e adicione as seguintes linhas abaixo dela:
   ```
   security:
     authorization: enabled
   ```
3. Salve o arquivo e saia do editor de texto.
4. Reinicie o serviço do MongoDB para aplicar as alterações:
   ```
   sudo systemctl restart mongod
   ```

Passo 3: Criação das tabelas
1. Abra o terminal e inicie o shell do MongoDB:
   ```
   mongo
   ```
2. Digite o seguinte comando para selecionar o banco de dados `iDB` (caso ainda não exista, ele será criado automaticamente):
   ```
   use iDB
   ```
3. Crie a tabela "Despesa" e insira os campos desejados:
   ```
   db.createCollection("Despesa")
   ```
4. Crie a tabela "Recorrente" e insira os campos desejados:
   ```
   db.createCollection("Recorrente")
   ```
5. Para adicionar a coluna "idUser" na tabela "Despesa", você pode executar o seguinte comando:
   ```
   db.Despesa.updateMany({}, { $set: { idUser: null } })
   ```
   Isso adicionará a coluna "idUser" em todos os documentos existentes na tabela "Despesa" e definirá o valor inicial como nulo. Certifique-se de atualizar os documentos posteriormente com os valores corretos.

Para continuar a criação das tabelas no MongoDB, conforme mencionado, você pode seguir os passos a seguir:

Passo 4: Criação da tabela "Usuario"
1. No shell do MongoDB, digite o seguinte comando para criar a tabela "Usuario" e definir os campos desejados:
   ```
   db.createCollection("Usuario", {
     validator: {
       $jsonSchema: {
         bsonType: "object",
         required: ["ID", "Nome", "Login", "Senha", "Foto", "Role"],
         properties: {
           ID: {
             bsonType: "int",
             description: "ID do usuário"
           },
           Nome: {
             bsonType: "string",
             description: "Nome do usuário"
           },
           Login: {
             bsonType: "string",
             description: "Login do usuário"
           },
           Senha: {
             bsonType: "string",
             description: "Senha do usuário"
           },
           Foto: {
             bsonType: "string",
             description: "Foto do usuário"
           },
           Role: {
             bsonType: "string",
             description: "Papel do usuário"
           }
         }
       }
     }
   })
   ```
2. A tabela "Usuario" será criada com os campos especificados.

Passo 5: Associação das tabelas
1. Para estabelecer a associação entre as tabelas, você precisa adicionar referências aos campos relevantes.
2. Na tabela "Despesa", você já possui a coluna "idUser" que está associada ao ID da tabela "Usuario".
3. Na tabela "Recorrente", você precisa adicionar a coluna "idDespesa" que será associada ao ID da tabela "Despesa". Para fazer isso, execute o seguinte comando:
   ```
   db.Recorrente.updateMany({}, { $set: { idDespesa: null } })
   ```
   Isso adicionará a coluna "idDespesa" em todos os documentos existentes na tabela "Recorrente" e definirá o valor inicial como nulo. Lembre-se de atualizar os documentos posteriormente com os valores corretos.

Após executar esses passos, as tabelas "Usuario", "Despesa" e "Recorrente" estarão criadas no banco de dados MongoDB, com as colunas e associações definidas de acordo com as especificações mencionadas.

Lembre-se de adaptar as configurações de acordo com a sua aplicação e preferências específicas.

Continuando, agora vamos criar um usuário administrador para acessar o painel admin. 

Passo 6: Criação de um usuário administrador
1. No shell do MongoDB, digite o seguinte comando para inserir um usuário administrador na tabela "Usuario":
   ```
   db.Usuario.insertOne({
     ID: 1,
     Nome: "Administrador",
     Login: "admin",
     Senha: "senhaAdmin",
     Foto: "caminho/foto-admin.jpg",
     Role: "admin"
   })
   ```
   Esse comando insere um novo documento na tabela "Usuario" com os campos específicos para o usuário administrador.

Agora você tem um usuário administrador na tabela "Usuario" com o login "admin" e senha "senhaAdmin". Você pode ajustar essas informações conforme necessário.

Com as tabelas criadas e o usuário administrador definido, você pode prosseguir com o desenvolvimento do aplicativo iBolso utilizando Python, HTML e MongoDB, conforme planejado inicialmente.