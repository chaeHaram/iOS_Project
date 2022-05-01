//
//  ViewController.swift
//  MyCalendar
//
//  Created by Chae_Haram on 2022/03/31.
//

import UIKit
import FSCalendar

/*
    로직을 짠다. how to..
 1. 모델을 설정한다(모델 & DB) -> 어떤 데이터가 필요하고, 어디에 어떻게 뿌려줄것인가?
 2. UI 잡기 -> cell에 대한 설정은 하는 등, 디테일한 설정을 모델을 바탕으로 잡기.
 3. 화면 흐름도 -> 전환 순서 == 데이터의 흐름
 4. 세세한 설정 -> 화면 띄워주는 방식, ui 커스텀(색깔등등)
 */

class ViewController: UIViewController {
    
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        df.locale = Locale(identifier: "ko-KR")
        return df
    }()

    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarConfigure()
        makeTestData()
        tableViewConfigure()
        
        calendarView.reloadData()
        scheduleTableView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        scheduleTableView.reloadData()
    }
    
    func tableViewConfigure() {
        calendarView.delegate = self
        calendarView.dataSource = self
    }

    func calendarConfigure() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko-KR")
        
//        calendarView.calendarWeekdayView.weekdayLabels[3].text = "WED"
        
        //calendarView.scrollDirection = .vertical //수직
        calendarView.appearance.borderRadius = 0 // 사각형
        
        calendarView.appearance.selectionColor = .systemMint
        calendarView.appearance.todayColor = .systemPink
        calendarView.appearance.headerTitleColor = .brown
        
    }
    
    func makeTestData() {
        let list: [Schedule] = [
              Schedule(time: "오후 12시", title: "점심 먹기", date: strToDate(str: "2022/04/01")),
              Schedule(time: "오후  1시", title: "발표 하기", date: strToDate(str: "2022/04/01")),
              Schedule(time: "오후  3시", title: "프로젝트 회의", date: strToDate(str: "2022/04/01")),
              Schedule(time: "오전  8시", title: "기상", date: strToDate(str: "2022/04/04")),
              Schedule(time: "오전 10시", title: "모의 시험", date: strToDate(str: "2022/04/04")),
              Schedule(time: "오후  1시", title: "스터디", date: strToDate(str: "2022/04/06")),
              Schedule(time: "오후  3시", title: "과외", date: strToDate(str: "2022/04/11")),
              Schedule(time: "오후  5시", title: "과제하기", date: strToDate(str: "2022/04/13")),
              Schedule(time: "오전 11시", title: "본가 가기", date: strToDate(str: "2022/04/13")),
              Schedule(time: "오후  7시", title: "00이랑 술 약속", date: strToDate(str: "2022/04/20"))
            ]
        list.forEach { schedule in
            MyDB.dataList.append(schedule)
        }
    }
    
    func strToDate(str: String) -> Date {
        return dateFormatter.date(from: str)!
    }
    
}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for schedule in MyDB.dataList {
            let eventDate = schedule.date
            if eventDate == date {
                let count = MyDB.dataList.filter { schedule in
                    schedule.date == date
                }.count
                
                if count >= 3 {
                    return 3
                } else {
                    return count
                }
            }
        }
        
        return 0
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //dateLabel.text = dateFormatter.string(from: date)
        
        // 분기 처리 2개 -> 데이터가 있을 때, 없을 때
        /*
         오후 1시 > 점심먹기
         오후 2시 > 공부하기
         */
        let scheduleList = MyDB.dataList.filter { schedule in
            schedule.date == date
        }
        guard let  cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier) as? ScheduleTableViewCell else { return }
        if scheduleList.count > 0 {
            
            var text: String = ""
            
            for str in scheduleList {
                text.append("\(str.time) > \(str.title)\n")
            }
            
            cell.schedulesLabel.text = text
            
        } else {
            cell.schedulesLabel.text = "등록된 스케쥴이 없습니다."
        }
        
        
        // 화면 전환 코드, 데이터 리로드 코드
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDB.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let calendarCell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
        let list = MyDB.dataList[indexPath.row]
        calendarCell.dateLabel.text = dateFormatter.string(from: list.date)
        calendarCell.schedulesLabel.text = "\(list.time)>\(list.title)"
        
        return calendarCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
