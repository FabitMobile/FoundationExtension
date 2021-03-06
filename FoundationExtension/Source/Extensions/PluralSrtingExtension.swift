import Foundation

public extension String {
    func localizedPlural(withCount count: Int, bundle: Bundle = Bundle.main, tableName: String? = nil) -> String {
        let key = localizedKey(withCount: count)
        let format = NSLocalizedString(key,
                                       tableName: tableName,
                                       bundle: bundle,
                                       value: "",
                                       comment: "")
        let result = String(format: format, count)
        return result
    }

    // MARK: - private

    fileprivate func localizedKey(withCount count: Int) -> String {
        String(format: "%%d %@ (plural rule: %@)", self, TTTRussianPluralRuleForCount(count: count))
    }
}

// TTTLocalizedPluralString.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

private let kTTTZeroPluralRule = "zero"
private let kTTTOnePluralRule = "one"
private let kTTTTwoPluralRule = "two"
private let kTTTFewPluralRule = "few"
private let kTTTManyPluralRule = "many"
private let kTTTOtherPluralRule = "other"

fileprivate extension String {
    func TTTRussianPluralRuleForCount(count: Int) -> String {
        let mod10: Int = count % 10
        let mod100: Int = count % 100
        switch mod100 {
        case 11, 12, 13, 14:
            break
        default:
            switch mod10 {
            case 1:
                return kTTTOnePluralRule
            case 2, 3, 4:
                return kTTTFewPluralRule
            default:
                break
            }
        }
        return kTTTManyPluralRule
    }
}
