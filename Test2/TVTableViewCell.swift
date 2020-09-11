
import UIKit

class TVTableViewCell: UITableViewCell {
  
  var needsImage = true

    @IBOutlet weak var TVImage: UIImageView!
    @IBOutlet weak var TVLabelName: UILabel!
    @IBOutlet weak var TVLabelDuration: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.needsImage = false
        self.TVLabelName.text = ""
        self.TVLabelDuration.text = ""
        self.TVImage.image = nil
  }
  
    fileprivate func myDateDifference (_ start: Date,_ end: Date)  -> Int?{
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        return calendar.dateComponents([.day], from: date1, to: date2).day
    }
    
    fileprivate func convertToDate(_ date: String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)!
    }
    
    func configure(with show: Show) {
    self.TVLabelName.text = show.name
    self.TVLabelDuration.text = show.name
    
    if let startDate = show.start_date {
      if let endDate = show.end_date {
        
        let start = convertToDate(startDate)
        let end = convertToDate(endDate)
        self.TVLabelDuration.text = "\(myDateDifference(start, end))"
        
      }else{
            let start = convertToDate(startDate)
            let end = Date()
            
            self.TVLabelDuration.text = "\(myDateDifference(start, end))"
        }
    }
    
    if let cachedImage = ImageCache.shared.retrieveImage(with: show.image_thumbnail_path) {
      self.TVImage.image = cachedImage
    } else {
        URLSession.shared.dataTask(with: show.image_thumbnail_path) { (data, _, _) in
        guard let data = data else { return }
        guard let TVSprite = try? JSONDecoder().decode(ShowSprite.self, from: data) else { return }
        URLSession.shared.dataTask(with: TVSprite.spriteURL) { (data, _, _) in
          guard let data = data else { return }
          guard let showImage = UIImage(data: data) else { return }
            ImageCache.shared.saveImage(with: show.image_thumbnail_path, image: showImage)
          guard self.needsImage else {
            self.needsImage = true
            return
          }
          DispatchQueue.main.async {
            self.TVImage.image = showImage
          }
        }.resume()
      }.resume()
    }
  }
}
