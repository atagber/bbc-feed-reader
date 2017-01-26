import UIKit

public final class NewsPostsDataSource: NSObject, UITableViewDataSource {
  fileprivate var newsPosts: [NewsPost] = []

  public func load(values: [NewsPost]) {
    self.newsPosts = values
  }

  public func value(atIndexPath indexPath: IndexPath) -> NewsPost {
    return self.newsPosts[indexPath.row]
  }

  // MARK: UITableViewDataSource

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NewsPostCell.defaultReusableId) as! NewsPostCell
    let value = self.value(atIndexPath: indexPath)

    cell.configureWith(value: value)

    return cell
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.newsPosts.count
  }
}
