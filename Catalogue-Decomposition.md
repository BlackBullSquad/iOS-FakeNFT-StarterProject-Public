// Catalogue-Epic-Plan.md

---

# Предварительные работы:

## Удалить сториборды — [#21](https://github.com/BlackBullSquad/iOS-FakeNFT-StarterProject-Public/issues/21) (eta: 0:05)

## Обновить дизайн систему:
- Добавить стилевые цвета — [#54](https://github.com/BlackBullSquad/iOS-FakeNFT-StarterProject-Public/pull/54) — (eta: 0:30, spent: 2:00 )
- Добавить стилевые шрифты — [#3](https://github.com/orgs/BlackBullSquad/projects/1?pane=issue&itemId=28074953)
- Реализовать переиспользуемый объект иконку-аватарку (фото NFT, с лайком (действие по closure) и возможностью при создании экземпляра этого объекта задать его размер). Использовать KIngfisher. — [#5](https://github.com/BlackBullSquad/iOS-FakeNFT-StarterProject-Public/issues/37) — (eta: 1:00, spent: 4:00)

## Таббар — [#21](https://github.com/BlackBullSquad/iOS-FakeNFT-StarterProject-Public/issues/21) — (eta: 0:30, spent: 0:30)
- Переделать таббар кодом
	- Сделать настройку таббара в отдельной структуре
	- Убрать вкладку "Статистика"
	- Сделать вьюконтроллеры-заглушки для каждого таба
- Добавить навбар 

Итого: ETA — 2:05, а реальность 6:30

---

# Каталог:
*Каталог коллекций NFT*

---

`UITableView` — таблица по одной ячейке в секции. В каждой секции обложка коллекции (картинка), кол-во NFT в коллекции и картинка (обложка коллекции)

---

## Возможные действия пользователя
- Тап на название коллекции — уводит на страницу коллекции —  [#26](https://github.com/BlackBullSquad/iOS-FakeNFT-StarterProject-Public/issues/32)
- Кнопка сортировки в `UINavigationController` — открывает `UIAlertController` в котором можно выбрать сортировку по кол-ву NFT в коллекции или по названию.

---

## Как получать данные?
Реализовать сервис, который будет получать DTO-модели от сетевого слоя и конвертировать их в бизнес-модели. `CollectionProvider`

---

## Паттерн
`MVVM`

---

## Задачи:

- [x] Сделать сервис `CollectionProvider` — (eta: 1:00)
- [x] Сделать переиспользуемую ячейку для таблицы — (eta: 2:00)
- [x] Реализовать таблицу с источником данных `DiffableDataSource` — (eta: 4:00)
- [x] Сделать сортировку таблицы — (eta: 2:00)
- [x] Общая вёрстка сцены — (eta: 1:30)

Итого: ETA — 10:30, а реальность — 16:00

---

# Коллекция

_Страница для просмотра выбранной коллекции NFT_

---

## Состоит из:
- Cover (обложки) коллекции
- Названия коллекции
- Окружности окрашенной в цвет коллекции
- Автора коллекции 
- Описания коллекции
- Трехколоночная CollectionView — Экран: Коллекция / UICollectionView

---

## Возможные действия
- Вернуться назад (NavigationViewController left button)
- лайкнуть NFT
- положить NFT в корзину 
- Перейти на страницу отдельного NFT
- Открыть `WebView` с информацией об авторе

---

## Паттерн:
`MVVM`

---

## Задачи
- [ ] Реализовать переиспользуемую ячейку для `UICollectionView` — (eta: 1:30)
- [ ] Сделать ViewModel — (eta: 1:30) 
- [ ] Реализовать `UICollection` (тут можно обойтись без `DiffableDataSource`) — (eta: 1:30)
- [ ] Сделать `WebView` для открытия страницы автора — (eta: 1:00)

---
#### Reference
[Декомпозиция всех задач](https://github.com/orgs/BlackBullSquad/projects/1?pane=issue&itemId=28074953) на Github канбан-доске 
