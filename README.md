# CONVIVA - Conectando Pessoas. Movendo Vidas.

Aplicativo mobile completo em Flutter desenvolvido para combater a solidão na terceira idade, incentivar a participação em eventos e facilitar a mobilidade solidária até as atividades.

---

## 🎨 Fidelidade aos Mockups & Design System

O aplicativo foi construído com rigorosa fidelidade estética aos mockups visuais incluídos no projeto:

- `01-home.png`: Tela inicial acolhedora com saudação calorosa, busca, cards detalhados e status.
- `02-evento-futuro.png`: Detalhes do evento em breve (banner verde pinheiro, confirmação de presença e participantes).
- `03-evento-lotado.png`: Detalhes do evento com vagas esgotadas (banner terracota, botão de lista de espera e conexão de participantes).
- `04-evento-realizado.png`: Detalhes de evento passado (banner ocre dourado, feedback de comparecimento e registro histórico).

---

## 🚀 Funcionalidades Principais (CRUD Completo + Interatividade)

### 1. CRUD de Eventos

- **Create**: Formulário completo de criação com templates rápidos e status inicial.
- **Read**: Listagem na Home com busca em tempo real e filtros dinâmicos por categorias e status (`Em breve`, `Lotados`, `Aconteceu`).
- **Update**: Edição de todas as informações do evento e **Simulador de Status ao Vivo** no detalhe do evento para alternar entre os layouts dos mockups (02, 03 e 04) instantaneamente.
- **Delete**: Exclusão com confirmação e SnackBar de "Desfazer" (Undo).
- **Duplicate**: Clonagem rápida de eventos para demonstração.

### 2. CRUD de Participantes & Presença

- Adicionar novos idosos participantes diretamente no evento.
- Botão interativo "+ Adicionar" / "✓ Adicionado" para criar laços de amizade.
- Lista de presença do organizador com percentual de comparecimento em tempo real e exportação CSV.

### 3. CRUD de Caronas Solidárias

- Solicitação de transporte acessível pelo idoso.
- Painel do motorista voluntário com aceitação de corridas, telemetria e rota GPS simulada interativa.

### 4. Visualizador de Mockups Integrado

- Modal com abas para comparar as telas reais com os 4 mockups PNG originais (`01`, `02`, `03`, `04`).
- Botão para restaurar os dados originais dos mockups a qualquer momento.

---

## 📱 Como Executar

```bash
# Executar no navegador Edge (visualização rápida):
flutter run -d edge

# Executar como aplicativo nativo do Windows:
flutter run -d windows

# Executar em emulador ou dispositivo Android conectado:
flutter run
```
