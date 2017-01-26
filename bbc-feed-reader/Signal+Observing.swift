import Foundation
import ReactiveCocoa
import ReactiveSwift

extension Signal {
  public func forUI() -> Signal<Value, Error> {
    return self.observe(on: UIScheduler())
  }
}
