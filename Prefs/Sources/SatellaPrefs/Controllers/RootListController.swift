import Preferences

final class RootListController: PSListController {
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            }
            
            var specifiers: NSMutableArray = .init()
            
            SpecifierFactory.add([
                GroupCell(name: "عام", footerText: ""),
                ToggleCell(name: "تفعيل الأداة", key: "isEnabled", defaultValue: true)
            ], to: &specifiers, in: self)
            
            if PrefsHelper.getValue(for: "isEnabled", fallback: true) as? Bool == true {
                SpecifierFactory.add([
                    ToggleCell(name: "إيصالات وهمية (Receipts)", key: "isReceipt", defaultValue: false),
                    ToggleCell(name: "مراقب المعاملات (Observer)", key: "isObserver", defaultValue: false),
                    ToggleCell(name: "تطبيقات مثبتة خارجياً (Sideloaded)", key: "isSideloaded", defaultValue: false),
                    ToggleCell(name: "الوضع الخفي (Stealth)", key: "isStealth", defaultValue: false),
                    ToggleCell(name: "سعر 0.01 (0,01 Price)", key: "isPriceZero", defaultValue: false)
                ], to: &specifiers, in: self)
            }
            
            SpecifierFactory.add([
                GroupCell(name: "التحكم في الحقن", footerText: ""),
                ToggleCell(name: "الحقن الشامل (Global Injection)", key: "isGloballyInjected", defaultValue: false),
                AppsCell(name: "التطبيقات المفعلة", key: "apps", defaultValue: false),
                GroupCell(name: "الروابط", footerText: ""),
                ButtonCell(name: "الكود المصدري (GitHub)", action: #selector(Self.openSource)),
                ButtonCell(name: "مجتمع CyPwn على Discord", action: #selector(Self.openCyPwn)),
                GroupCell(name: "", footerText: poem)
            ], to: &specifiers, in: self)
            
            setValue(specifiers, forKey: "_specifiers")
            return specifiers
        }
        
        set { super.specifiers = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "تطبيق",
            style: .done,
            target: self,
            action: #selector(respring)
        )
        
        table.tableHeaderView = HeaderView(style: .default, reuseIdentifier: "HeaderCell")
    }
    
    override func setPreferenceValue(_ value: Any, specifier: PSSpecifier) {
        super.setPreferenceValue(value, specifier: specifier)
        
        guard specifier.identifier == "isEnabled" else {
            return
        }
        
        if value as? Bool == true {
            var newSpecifiers: NSMutableArray = .init()
            
            SpecifierFactory.add([
                ToggleCell(name: "إيصالات وهمية (Receipts)", key: "isReceipt", defaultValue: false),
                ToggleCell(name: "مراقب المعاملات (Observer)", key: "isObserver", defaultValue: false),
                ToggleCell(name: "تطبيقات مثبتة خارجياً (Sideloaded)", key: "isSideloaded", defaultValue: false),
                ToggleCell(name: "الوضع الخفي (Stealth)", key: "isStealth", defaultValue: false),
                ToggleCell(name: "سعر 0.01 (0,01 Price)", key: "isPriceZero", defaultValue: false)
            ], to: &newSpecifiers, in: self)
            
            self.insertContiguousSpecifiers(newSpecifiers as? [Any], afterSpecifierID: "isEnabled", animated: true)
        } else {
            let hiddenIDs: [Any] = self.specifiers(forIDs: ["isReceipt", "isObserver", "isSideloaded", "isStealth", "isPriceZero"])
            self.removeContiguousSpecifiers(hiddenIDs, animated: true)
        }
        
        table.tableHeaderView = HeaderView(style: .default, reuseIdentifier: nil)
    }
    
    @objc private func respring() {
        PrefsHelper.write()
        PrefsHelper.respring(withView: view)
    }
    
    @objc private func openSource() {
        if let url: URL = .init(string: "https://github.com/Paisseon/Satella") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func openCyPwn() {
        if let url: URL = .init(string: "https://discord.gg/cypwn") {
            UIApplication.shared.open(url)
        }
    }
    
    private let poem: String = """
البحث عن المعنى رحلة مليئة بالوحدة
عبر عالم بارد وقاسٍ لا يرحم
ظننا أننا وجدنا حريتنا
لكنها لم تكن سوى وهم، ولحظة عابرة من السعادة

تركنا ماضينا خلفنا ظانين أننا نبدأ من جديد
لكن قيود حياتنا السابقة ظلت تقيدنا
ومهما ابتعدنا ركضاً، لم نستطع الهروب
فأشباح الماضي تلاحقنا مع كل خطوة نخطوها
                          
ظننا أن الحرية تعني فرصة لإيجاد غايتنا
لكن ما وجدناه لم يكن سوى الفراغ واليأس
أدركنا حينها أن الحرية الحقيقية تنبع من الداخل
من التخلي عن آلام وجراح الماضي
                          
حينها فقط يمكننا أن نبدأ في التعافي حقاً
ونجد المعنى والغاية التي نبحث عنها
علينا مواجهة مخاوفنا ومسامحة من أخطأ بحقنا
لنكسر الأغلال التي تقيدنا وننعم بالحرية أخيراً
"""
}
