//
//  main_counter.swift
//  uitest
//
//  Created by Артём Макогон on 11.11.2021.
//

import Foundation
import SwiftUI


class CounterElement {
    
    init() {
        is_pushed_ = false
    }
    
    func ChangeState() -> Void {
        is_pushed_ = !is_pushed_;
    }
    
    var is_pushed_: Bool
}

class ProgressBar {
    
}

class Counter {
    init(checkbox_count: Int = 5){
        kCheckboxCount = checkbox_count;
        counter_elements_ = []
        for _ in 1...checkbox_count {
            counter_elements_.append(CounterElement());
        }
        total_progress = 0.0
    }
    
    func ChangeElementState(position: Int) {
        counter_elements_[position].ChangeState();
        total_progress = GetTotalProgress()
    }
    
    func GetTotalProgress() -> Double {
        var cnt = 0
        for el in counter_elements_ {
            if (el.is_pushed_){
                cnt += 1
            }
        }
        return Double(cnt) / Double(kCheckboxCount)
    }
    
    func IsActive(position: Int) -> Bool {
        return counter_elements_[position].is_pushed_
    }
    
    var kCheckboxCount : Int;
    var counter_elements_ : [CounterElement];
    var total_progress: Double
}
