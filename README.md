# RMRPullToRefresh
==

Репозиторий pull to refresh контрола для UIScrollView, UITableView, UICollectionView для платформы iOS.


`pod 'RMRPullToRefresh', :git => "https://github.com/imerkulov/RMRPullToRefresh.git"`

Как добавить?
--------

```swift
import RMRPullToRefresh

var pullToRefresh: RMRPullToRefresh?

pullToRefresh = RMRPullToRefresh(scrollView: tableView, 
                                   position: examplePosition()) { [weak self] _ in
            // Загрузка данных
            self?.service.load() { _ in
                // Завершение загрузки
                self?.pullToRefresh?.stopLoading()
            })
        }
```

Как конфигурировать?
--------

Кастомизация:

Поддерживается три состояния контроллера:
```swift
enum RMRPullToRefreshState: Int {
    case Stopped // Состояние, когда загрузка завершена или контрол невидим на экране
    case Dragging // Состояние, когда пользователь скроллит ScrollView/TableView/CollectionView
    case Loading  // Состояние, когда идёт загрузка данных (пользователь пользователь завершил скроллинг)
}
```

Два типа завершения загрузки данных: 
```swift
enum RMRPullToRefreshResult: Int {
    case Success // Загрузка данных завершилась успешно 
    case Error // Загрузка данных завершилась с ошибкой
}
```

Для каждого состояния и типа завершения загрузки данных можно сконфигурировать view (RMRPullToRefreshView):
```swift
if let pullToRefreshView = exampleView() {
  pullToRefresh?.configureView(pullToRefreshView, state: .Dragging, result: .Success)
  pullToRefresh?.configureView(pullToRefreshView, state: .Loading, result: .Success)
}
```

Изменить высоту:

```swift
pullToRefresh?.height = 70.0
```

Изменить цвет бэкграунда:
```swift
pullToRefresh?.backgroundColor = UIColor(red: 16.0/255.0, 
                                       green: 192.0/255.0, 
                                        blue: 119.0/255.0, 
                                       alpha: 1.0)
```
