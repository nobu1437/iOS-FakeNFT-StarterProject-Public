import Foundation

struct CurrenciesScreenModel {
    let currencies: [CurrencyModel]
    // реализация  ссылка на пользовательское соглашение будет выполнена в 3/3 части эпика
    let userAgreement = URL(string: "https://www.google.com")
}
