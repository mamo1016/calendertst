//
//  DateManager.swift
//  calendertst
//
//  Created by 上田　護 on 2018/03/02.
//  Copyright © 2018年 上田　護. All rights reserved.
//

import UIKit

class DateManager: NSObject {
    var selectDay = Date()//現在の日付
    var biginDay = Date()
    var endDay = Date()
    
    let calendar = Calendar.current
    
    //月カレンダーの始点になる日を求める
    func BeginOfMonthCalender() -> Date{
        //日付の要素を1日にする
        var components = calendar.dateComponents([.year,.month,.day], from: selectDay)
        components.day = 1//この日がある週からカレンダーを表示
        let firstOfMonth = Calendar.current.date(from: components)
        //曜日を調べて、その要素数だけ戻ったものがカレンダーの左上(日曜日=1 土曜日=7　なので1足した状態で戻る)
        let dayOfWeek = calendar.component(.weekday,from:firstOfMonth!)
        
        return calendar.date(byAdding: .day, value: 1-dayOfWeek, to: firstOfMonth!)!
    }
    
    //月カレンダーの終点になる日を求める
    func EndOfMonthCalendar() ->Date{
        //次の月初めを取得
        let nextmonth = calendar.nextDate(after: selectDay, matching: DateComponents(day:1), matchingPolicy: Calendar.MatchingPolicy.nextTime)
        //曜日を調べて、その要素数だけ進んだものが右下(次の月の初めで計算している事に注意)
        let dayOfWeek = calendar.component(.weekday,from: nextmonth!)
        print(calendar.date(byAdding: .day, value: 7-dayOfWeek, to: nextmonth!)!)
        return calendar.date(byAdding: .day, value: 7-dayOfWeek, to: nextmonth!)!
    }
    
    //月ごとのセルの数を出すメソッド
    func daysAcquisition() -> Int{
        
        //始まりの日と終わりの日を取得
        biginDay = BeginOfMonthCalender()
        endDay = EndOfMonthCalendar()
        //始点から終点の日数
        return calendar.dateComponents([.day], from:biginDay ,to:endDay).day! + 1
    }
    
    //カレンダーの始点から指定した日数を加算した日付を返す
    func conversionDateFormat(index: Int)->String{
        let currentday = calendar.date(byAdding: .day, value: index, to: biginDay)
        return calendar.component(.day, from: currentday!).description
    }

    //今セレクトされているselectDayの年月をテキストで出力
    func CalendarHeader()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        
        return formatter.string(from: selectDay)
    }
    //今セレクトされているselectDayの年月をテキストで出力
    func CalendarHeader2()->Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMM"
        
        return Int(formatter.string(from: selectDay))!
    }

    
    /*
     表示月を変える操作
     */
    
    //SelectDayを一ヶ月戻す
    func preMonthCalendar(){
        selectDay = calendar.date(byAdding: .month, value: -1, to: selectDay)!
    }
    
    //SelectDayを1か月進ませる
    func nextMonthCalendar(){
        selectDay = calendar.date(byAdding: .month, value: 1, to: selectDay)!
    }
    
    
    //SelectDayを1日戻す
    func preDayCalendar(){
        selectDay = calendar.date(byAdding: .day, value: -1, to: selectDay)!
    }
    
    //SelectDayを1日進む
    func nextDayCalendar(){
        selectDay = calendar.date(byAdding: .day, value: 1, to: selectDay)!
    }
}
