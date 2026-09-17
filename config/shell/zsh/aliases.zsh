alias lg="lazygit"
alias cdp="cd ~/projects/"
alias cdppn="cdpp && nvim"
alias cdppg="cdpp ~/projects/gli"
alias cdppgn="cdppg && nvim"
alias v="nvim"
alias v.="nvim ."
alias la="ls -a"
alias javav="sudo update-alternatives --config java"

# Helpers for Spring Boot / Flyway / Maven
alias clean='mvn flyway:clean "-Dflyway.url=jdbc:oracle:thin:@//localhost:1521/orcl" "-Dflyway.user=appdata" "-Dflyway.password=app" "-Dflyway.cleanDisabled=false"'
alias migrate='mvn flyway:migrate "-Dflyway.url=jdbc:oracle:thin:@//localhost:1521/orcl" "-Dflyway.user=appdata" "-Dflyway.password=app"'
alias repair='mvn flyway:repair "-Dflyway.url=jdbc:oracle:thin:@//localhost:1521/orcl" "-Dflyway.user=appdata" "-Dflyway.password=app"'
alias run='mvn spring-boot:run'
alias ccompile='mvn clean compile'
alias cinstall='mvn clean install'

