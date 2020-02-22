import WatchKit

class InterfaceController: WKInterfaceController {
    
    //MARK: UI Components
    @IBOutlet var mineSpace0_0: WKInterfaceButton!
    @IBOutlet var mineSpace0_1: WKInterfaceButton!
    @IBOutlet var mineSpace0_2: WKInterfaceButton!
    @IBOutlet var mineSpace0_3: WKInterfaceButton!
    @IBOutlet var mineSpace0_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace1_0: WKInterfaceButton!
    @IBOutlet var mineSpace1_1: WKInterfaceButton!
    @IBOutlet var mineSpace1_2: WKInterfaceButton!
    @IBOutlet var mineSpace1_3: WKInterfaceButton!
    @IBOutlet var mineSpace1_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace2_0: WKInterfaceButton!
    @IBOutlet var mineSpace2_1: WKInterfaceButton!
    @IBOutlet var mineSpace2_2: WKInterfaceButton!
    @IBOutlet var mineSpace2_3: WKInterfaceButton!
    @IBOutlet var mineSpace2_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace3_0: WKInterfaceButton!
    @IBOutlet var mineSpace3_1: WKInterfaceButton!
    @IBOutlet var mineSpace3_2: WKInterfaceButton!
    @IBOutlet var mineSpace3_3: WKInterfaceButton!
    @IBOutlet var mineSpace3_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace4_0: WKInterfaceButton!
    @IBOutlet var mineSpace4_1: WKInterfaceButton!
    @IBOutlet var mineSpace4_2: WKInterfaceButton!
    @IBOutlet var mineSpace4_3: WKInterfaceButton!
    @IBOutlet var mineSpace4_4: WKInterfaceButton!
    
    @IBOutlet var flagButton: WKInterfaceButton!
    @IBOutlet var mineCountLabel: WKInterfaceLabel!
    
    //MARK: UI Actions
    
    @IBAction func checkMine0_0() { check(Point(x: 0, y: 0)) }
    @IBAction func checkMine0_1() { check(Point(x: 1, y: 0)) }
    @IBAction func checkMine0_2() { check(Point(x: 2, y: 0)) }
    @IBAction func checkMine0_3() { check(Point(x: 3, y: 0)) }
    @IBAction func checkMine0_4() { check(Point(x: 4, y: 0)) }
    
    @IBAction func checkMine1_0() { check(Point(x: 0, y: 1)) }
    @IBAction func checkMine1_1() { check(Point(x: 1, y: 1)) }
    @IBAction func checkMine1_2() { check(Point(x: 2, y: 1)) }
    @IBAction func checkMine1_3() { check(Point(x: 3, y: 1)) }
    @IBAction func checkMine1_4() { check(Point(x: 4, y: 1)) }
    
    @IBAction func checkMine2_0() { check(Point(x: 0, y: 2)) }
    @IBAction func checkMine2_1() { check(Point(x: 1, y: 2)) }
    @IBAction func checkMine2_2() { check(Point(x: 2, y: 2)) }
    @IBAction func checkMine2_3() { check(Point(x: 3, y: 2)) }
    @IBAction func checkMine2_4() { check(Point(x: 4, y: 2)) }
    
    @IBAction func checkMine3_0() { check(Point(x: 0, y: 3)) }
    @IBAction func checkMine3_1() { check(Point(x: 1, y: 3)) }
    @IBAction func checkMine3_2() { check(Point(x: 2, y: 3)) }
    @IBAction func checkMine3_3() { check(Point(x: 3, y: 3)) }
    @IBAction func checkMine3_4() { check(Point(x: 4, y: 3)) }
    
    @IBAction func checkMine4_0() { check(Point(x: 0, y: 4)) }
    @IBAction func checkMine4_1() { check(Point(x: 1, y: 4)) }
    @IBAction func checkMine4_2() { check(Point(x: 2, y: 4)) }
    @IBAction func checkMine4_3() { check(Point(x: 3, y: 4)) }
    @IBAction func checkMine4_4() { check(Point(x: 4, y: 4)) }
    
    @IBAction func resetPressed() {
        if flagging {toggleFlagging()}
        
        setup()
        for row in mineButtons {
            for cell in row {
                cell.setTitle("")
            }
        }
        updateMineCountLabel()
    }
    
    @IBAction func toggleFlagging() {
        if minefield.hasStarted{
            flagging.toggle()
            flagButton.setBackgroundColor(flagging ? UIColor.red : UIColor.clear)
        }
    }
    
    func setup(){
        minefield = MineField(width: 5, height: 5)
        flaggedCells = Set<WKInterfaceButton>()
        clearedCells = Set<WKInterfaceButton>()
    }
    
    private var flagging = false
    private var mineButtons : Array<Array<WKInterfaceButton>>!
    private var minefield : MineField!
    private var flaggedCells : Set<WKInterfaceButton>!
    private var clearedCells : Set<WKInterfaceButton>!
    
    private func check(_ point: Point){
        
        if minefield.isExploded {
            return
        }
        
        let cell = mineButtons[point.y][point.x]
        
        if !flagging && flaggedCells.contains(cell){
            deFlag(cell)
            return
        }
        
        if flagging && !clearedCells.contains(cell) {
            flag(cell)
            checkForCompletion()
            return
        }
        
        let status = minefield.checkMine(point)
        if status.isMine {
            showAllMines()
            WKInterfaceDevice().play(.failure)
            return
        }
        
        cell.setTitle("\(status.adjacentMineCount)")
        clearedCells.insert(cell)
        checkForCompletion()
    }
    
    private func checkForCompletion(){
        if clearedCells.count + min(flaggedCells.count,minefield.mineCount) == 25 {
            mineCountLabel.setText("👍")
            WKInterfaceDevice().play(.success)
        }
    }
    
    private func showAllMines(){
        for minePoint in minefield.mineLocations() {
            mineButtons[minePoint.y][minePoint.x].setTitle("💣")
            mineCountLabel.setText("0 x")
        }
    }
    
    private func deFlag(_ cell: WKInterfaceButton){
        cell.setTitle("")
        flaggedCells.remove(at: flaggedCells.firstIndex(of: cell)!)
        updateMineCountLabel()
    }
    
    private func flag(_ cell: WKInterfaceButton){
        if !flaggedCells.contains(cell){
            cell.setTitle("🇰🇵")
            flaggedCells.insert(cell)
            updateMineCountLabel()
        }
    }
    
    private func updateMineCountLabel(){
        let minesLeft = minefield.mineCount - flaggedCells.count
        mineCountLabel.setText("\(minesLeft) x")
    }
    
    override func awake(withContext context: Any?) {
        setup()
        
        mineButtons = Array<Array<WKInterfaceButton>>()
        for _ in 0..<5 {
            mineButtons.append([WKInterfaceButton]())
        }
        
        //add buttons to array
        mineButtons[0].append(mineSpace0_0)
        mineButtons[0].append(mineSpace0_1)
        mineButtons[0].append(mineSpace0_2)
        mineButtons[0].append(mineSpace0_3)
        mineButtons[0].append(mineSpace0_4)
        
        mineButtons[1].append(mineSpace1_0)
        mineButtons[1].append(mineSpace1_1)
        mineButtons[1].append(mineSpace1_2)
        mineButtons[1].append(mineSpace1_3)
        mineButtons[1].append(mineSpace1_4)
        
        mineButtons[2].append(mineSpace2_0)
        mineButtons[2].append(mineSpace2_1)
        mineButtons[2].append(mineSpace2_2)
        mineButtons[2].append(mineSpace2_3)
        mineButtons[2].append(mineSpace2_4)
        
        mineButtons[3].append(mineSpace3_0)
        mineButtons[3].append(mineSpace3_1)
        mineButtons[3].append(mineSpace3_2)
        mineButtons[3].append(mineSpace3_3)
        mineButtons[3].append(mineSpace3_4)
        
        mineButtons[4].append(mineSpace4_0)
        mineButtons[4].append(mineSpace4_1)
        mineButtons[4].append(mineSpace4_2)
        mineButtons[4].append(mineSpace4_3)
        mineButtons[4].append(mineSpace4_4)
    }

}
