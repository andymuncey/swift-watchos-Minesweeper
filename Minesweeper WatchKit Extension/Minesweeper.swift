import Foundation

struct Point : Equatable{
   
    var x: Int
    var y: Int
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

struct MineInfo {
    var isMine = false
    var adjacentMineCount = 0
}

class MineField {
    
    private(set) var hasStarted = false
    private(set) var isExploded = false
    private(set) var mineCount : Int
    private var field = Array<Array<MineInfo>>()
    
    private var width: Int
    private var height: Int
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height
        mineCount = Int(sqrt(Double(width * height)))
        for _ in 0..<height {
            //create row
            var row = [MineInfo]()
            for _ in 0..<width {
                row.append(MineInfo())
            }
            field.append(row)
        }
    }
    
    func checkMine(_ point: Point) -> MineInfo{
        if !hasStarted{
            hasStarted = true
            determineMinesWithStart(point: point)
        }
        
        let location = field[point.y][point.x]
        if location.isMine {
            isExploded = true
        }
        var mineInfo = MineInfo()
        mineInfo.adjacentMineCount = location.adjacentMineCount
        mineInfo.isMine = location.isMine
        return mineInfo
    }
    
    
    private func determineMinesWithStart(point: Point){
        populateMines(mineCount, avoidingPoint: point)
        populateAdjacentMineCount()
    }
    
    private func populateMines(_ count: Int, avoidingPoint startPoint: Point){
        var mineLocations = [Point]()
        repeat {
            let randPoint = getRandomPoint(width: width, height: height)
            if startPoint != randPoint && !mineLocations.contains(randPoint){
                mineLocations.append(randPoint)
            }
        } while mineLocations.count < count
        
        for point in mineLocations {
            field[point.y][point.x].isMine = true
        }
    }
    
    func mineLocations() -> [Point] {
        var mines = [Point]()
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                if field[y][x].isMine {
                    mines.append(Point(x: x, y: y))
                }
            }
        }
        return mines
    }
    
    private func validNeighboursFor(point: Point) -> [Point] {
        var neighbours = [Point]()
        let minX = max(0,point.x - 1)
        let maxX = min(width-1,point.x + 1)
        let minY = max(0, point.y-1)
        let maxY = min(height-1,point.y+1)
        
        for x in minX...maxX {
            for y in minY...maxY {
                if !(point.x == x && point.y == y) {
                    neighbours.append(Point(x: x, y: y))
                }
            }
        }
        return neighbours
    }
    
    private func countMinesAt(points: [Point]) -> Int{
        
        return points.reduce(0, {$0 + (field[$1.y][$1.x].isMine ? 1 : 0)})
        
//        var count = 0
//        for point in points {
//            if field[point.y][point.x].isMine{
//                count += 1
//            }
//        }
//        return count
    }
    
    private func populateAdjacentMineCount(){
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                
                let neighbours = validNeighboursFor(point: Point(x: x, y: y))
                let nearbyMines = countMinesAt(points: neighbours)
                field[y][x].adjacentMineCount = nearbyMines
            }
        }
    }
    
    private func getRandomPoint(width: Int, height: Int) -> Point{
        let x = Int.random(in: 0..<width)
        let y = Int.random(in: 0..<height)
        return Point(x: x, y: y)
    }
}
