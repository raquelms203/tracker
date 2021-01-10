# Tracker

Aplicativo de mapeamento de coletas para Android e iOS usando Flutter e SQLite.

Para visualizar as telas do aplicativo, acesse: https://photos.app.goo.gl/AzrvhH6DDAZH9FGS6


### Observações

1. Para o mapeamento foi utilizado a API do Google Maps.

2. Para gerenciamento de estado foi utilizado o BLoC Pattern.

3. O banco de dados SQLite é salvo no armazenamento interno do dispositivo. Ao deletar o aplicativo os dados serão perdidos.

4. O aplicativo não foi testado no iOS.


### Instalação por arquivo no Android:

Transfira o arquivo para um dispositivo móvel e execute-o. Arquivo disponível na raíz do projeto em:  

> tracker.apk

### Instalação a partir do código fonte no Android:

Pré-requisitos: 

1. Ter o SDK do Android e Flutter instalados no computador. 
Caso não possua, siga o tutorial em: https://flutter.dev/docs/get-started/install

2. Ter um emulador ou dispositivo móvel Android com depuração USB habilitada. 
Para habilitar a depuração USB siga o tutorial em https://developer.android.com/studio/debug/dev-options?hl=pt-br

Com um dispositivo conectado ou emulador, execute o comando no terminal:
> flutter install

Ou para rodar o projeto:
> flutter run








