import Foundation

struct Point : Equatable, Hashable {
   
    var x: Int
    var y: Int
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
}


struct Cell {
    var isMine = false
    var adjacentMineCount = 0
}

class MineField {
    
    private(set) var hasStarted = false
    private(set) var isExploded = false
    private(set) var mineCount : Int
    private var field = Array<Array<Cell>>()
    
    private var width: Int
    private var height: Int
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height
        mineCount = Int(sqrt(Double(width * height)))
        for _ in 0..<height {
            var row = [Cell]()
            for _ in 0..<width {
                row.append(Cell())
            }
            field.append(row)
        }
    }
    
    func checkMine(_ point: Point) -> Cell{
        if !hasStarted{
            hasStarted = true
            determineMinesWithStart(point: point)
        }
        
        let location = field[point.y][point.x]
        if location.isMine {
            isExploded = true
        }
        var cell = Cell()
        cell.adjacentMineCount = location.adjacentMineCount
        cell.isMine = location.isMine
        return cell
    }
    
    
    private func determineMinesWithStart(point: Point){
        populateMines(mineCount, avoiding: point)
        populateAdjacentMineCount()
    }
    
    private func populateMines(_ count: Int, avoiding point: Point){
        var mineLocations = Set<Point>()
        repeat {
            let randPoint = randomPoint()
            if point != randPoint && !mineLocations.contains(randPoint){
                mineLocations.insert(randPoint)
            }
        } while mineLocations.count < count
        
        for point in mineLocations {
            field[point.y][point.x].isMine = true
        }
    }
    
    func mineLocations() -> Set<Point> {
        var mines = Set<Point>()
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                if field[y][x].isMine {
                    mines.insert(Point(x: x, y: y))
                }
            }
        }
        return mines
    }
    
    private func neighboursFor(_ point: Point) -> Set<Point> {
        var neighbours = Set<Point>()
        let minX = max(0,point.x - 1)
        let maxX = min(width-1,point.x + 1)
        let minY = max(0, point.y-1)
        let maxY = min(height-1,point.y+1)
        
        for x in minX...maxX {
            for y in minY...maxY {
                if !(point.x == x && point.y == y) {
                    neighbours.insert(Point(x: x, y: y))
                }
            }
        }
        return neighbours
    }
    
    private func adjacementMineCount(for point: Point) -> Int{
        return neighboursFor(point).reduce(0, {$0 + (field[$1.y][$1.x].isMine ? 1 : 0)})
    }
    
    private func populateAdjacentMineCount(){
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                field[y][x].adjacentMineCount = adjacementMineCount(for: Point(x: x, y: y))
            }
        }
    }
    
    private func randomPoint() -> Point{
        return Point(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
    }
}
