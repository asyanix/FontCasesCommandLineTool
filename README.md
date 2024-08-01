# FontCasesCommandLineTool

Command-line инструмент, который распознает тип кейса (из списка ниже) строки. Типы кейсов, которые можно обработать: camelCase, snake_case, kebab-case, PascalCase, Train-Case, SCREAMING_SNAKE_CASE, dot.case, path/case. 
Также можно указать желаемый тип кейса и программа вернет строку, сконвертированную в переданный кейс. Например, на вход поступило "fun/string/example" и "Train-Case", получаем "Fun-String-Example". 

Для работы с данным инструментом используйте следующие команды:

`swift run FontCasesTool fun_string_example`
Вывод будет: 
*The string that you want to process: fun_string_example*
*The result: snakeCase*

`swift run FontCasesTool fun_string_example --font-case PascalCase`
Вывод будет: 
*The string that you want to process: fun_string_example*
*The result: FunStringExample*
