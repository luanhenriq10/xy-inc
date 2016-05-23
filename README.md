# xy-inc

Para executar o projeto, basta baixa-lo via git (git remote add origin https://github.com/luanhenriq10/xy-inc && git pull origin master).

Após o pull do projeto, abra a pasta e abra o projeto e clique duas vezes em xy-inc.xcworkspace (Projeto com Pods) e não no xy-inc.xcodeproj

Após aberto o projeto no Xcode, é só dar build e run no projeto. :)

A Arquitetura pensada para esse teste de nivelamento foi a arquitetura MVVM -> Model View View Model. Essa arquitetura preza pela separação de responsábilidades (Inversão de controles, desacoplamento, injeção de dependencia dentre outros) e torna o aplicativo mais simples para a manuntenção. Esse padrão é bastante utilizado no desenvolvimento nos dias atuais se assemelhando bastante ao MVC. 

No projeto foi criado três pastas model, controller e services, sendo que o storyboard serve como uma view. Com isso, o model (modelo) encapsula os dados, sendo que o objeto principal da aplicação são os filmes (Movies). Os Services possuem o trabalho de conectar ao servidor (OMDb API) e retornam o resultado para os controllers. Os controllers realizam a comunicação entre modelo, service e view.

Para a realizações de testes na aplicação segue um exemplo:
    O app possui duas abas, uma de busca e outra de favoritos. Ao abrir a aplicação, o usuário se depara com a tela de pesquisa. Caso seja um dispositivo - Basta digitar um filme e clicar em buscar em seu teclado, caso esteja usando um simulador, clique com a tecla ENTER (Foi desenvolvido assim devido a usabilidade dos apps iOS, onde o usuário esta acostumado e preparado para clicar em buscar e não em um botão). 

    Após a confirmação do filme desejado, o sistema envia a requisição para o web service do OMDb e retorna o filme. Caso o filme existe é apresentado seu poster, o ano de estréia do filme, os atores, o genero e a duração. Mostrado o filme, o usuário pode adicionar o filme aos favoritos.
    
    Com isso, se o usuário adicionar aos favoritos, o filme é salvo no CoreData da aplicação juntamento com seus dados. 
    
    Após adicionado, é só clicar na aba de favoritos que o filme já estara adicionado a sua lista.

    Caso queira deletar o filme, basta arrastar para a esquerda e confirmar a ação de deletar.


Obs: Caso as dependencias não estejam instaladas, é só realizar pod install na pasta root do projeto.

