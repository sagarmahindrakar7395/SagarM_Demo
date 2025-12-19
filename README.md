SagarM_Demo — iOS app structured with **VIPER** (View, Interactor, Presenter, Entity, Router) for clean, testable modules.
The `Portfolio` module is fully modular (`PortfolioViewController`, `PortfolioPresenter`, `PortfolioInteractor`, `PortfolioRouter`, and `Cells`) and depends on shared services like `NetworkManager` and `CoreDataManager`.
UI is built **programmatically** using UIKit (custom views and cells); only the launch storyboard is retained for app launch.
Includes unit and UI tests (`SagarM_DemoTests`, `SagarM_DemoUITests`) to validate module boundaries and flows.
To run: open `SagarM_Demo.xcodeproj`, select a simulator, Build & Run — modules are independently testable and easy to extend.
