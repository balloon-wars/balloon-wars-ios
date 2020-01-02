import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellId = "rankCell"
    
    var gameScene: GameScene!
    
    var scoreTableView: UITableView!
    
    var currentGame: Game?
    // MARK: - UIViewController overrides
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }
    
    override func viewDidLoad() {
        
        ConnectionManager.instance.setup()
        EventBinder.bind(self, to: .gameUpdate, with: #selector(self.onUpdate(_:)))
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.setupGameScene()
        self.setupScoreTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupGameView()
        
        self.view.bringSubviewToFront(self.scoreTableView)
        
    }
    
    // MARK: - Setup methods
    
    
    func setupScoreTableView() {
        self.scoreTableView = UITableView()
        
        self.scoreTableView.delegate = self
        self.scoreTableView.dataSource = self
        self.scoreTableView.translatesAutoresizingMaskIntoConstraints = false

        self.scoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        
        self.view.addSubview(self.scoreTableView)

        self.scoreTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scoreTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scoreTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        self.scoreTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        
    }
    
    func setupGameScene() {
        
        let scene = GameScene(size: self.view.bounds.size)
        scene.backgroundColor = .white
        scene.viewController = self
        self.gameScene = scene
        
    }
    
    func setupGameView() {
        
        
        let view: SKView = {
            let view = SKView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(self.gameScene)
            
            return view
        }()
        
        self.view.addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    
    // MARK: - TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let game = self.currentGame {
            return game.players.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game = self.currentGame else { return UITableViewCell()}
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) else { return UITableViewCell()}
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        
        let currentPlayer = game.getOrderedScoreboard()[indexPath.item]
        let playerNameLabel = UILabel()
        
        playerNameLabel.text = "\(currentPlayer.kills)" + " - " + currentPlayer.id
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(playerNameLabel)
        
        playerNameLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
        playerNameLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        
        return cell
    }
    
    // MARK: - Callbacks
    
    @objc func onUpdate(_ notification: NSNotification){
        guard let update = notification.userInfo?["payload"] as? NetworkGame else { return }
        guard let game = update.game else { return }
        
        self.gameScene.updateGame(to: game)
        
        self.currentGame = game
        
        self.scoreTableView.reloadData()
    }
}
