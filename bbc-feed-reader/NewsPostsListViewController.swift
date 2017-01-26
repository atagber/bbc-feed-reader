import UIKit

class NewsPostsListViewController: UITableViewController {
  fileprivate let viewModel: NewsPostsListViewModelType = NewsPostsListViewModel()
  fileprivate let dataSource: NewsPostsDataSource = NewsPostsDataSource()
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.estimatedRowHeight = CGFloat(NewsPostCell.estimatedRowHeight)
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.dataSource = dataSource
    
    self.viewModel.inputs.viewDidLoad()
  }
  
  public override func bindViewModel() {
    super.bindViewModel()
    
    self.viewModel.outputs.goToNewsPost.forUI().observeValues(self.goTo(newsPost:))
    
    self.viewModel.outputs.newsPosts.forUI().observe { [weak self] event in
      self?.dataSource.load(values: event.value ?? [])
      self?.tableView.reloadData()
    }
  }
  
  public func goTo(newsPost: NewsPost) {
    // TODO: implement this method
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.viewModel.inputs.tapped(newsPost: self.dataSource.value(atIndexPath: indexPath))
  }
}
