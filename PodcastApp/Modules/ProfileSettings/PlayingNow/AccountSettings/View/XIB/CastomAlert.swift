import UIKit

class MyBtn:UIButton {
    var color: UIColor?
    var myView: UIView?
    var alert: CastomAlert?
    var void: (()->Void)?
}

class CastomAlert: UIView {
    var lable:UILabel?
    let top: CGFloat = 200
    let heightText: Double = 50
    let colorText: UIColor = .magenta
    var okBtn:MyBtn?
    let okBtnWidth:CGFloat = 50
    var cancelBtn:MyBtn?
    let cancelBtnWidth:CGFloat = 50
    let backgroundColorCancelBtn: UIColor = .white
    
    //static - функция доступна напрямую по имени класса!!!
    static func instanseFromNib() -> CastomAlert {
        //UINib - обращение к файлу с *.xib разрешением по имени c точным соответствием регистра "myXIBview"
        //instantiate(withOwner: nil, options: nil)[0] - в массив view добовляется view единственное, чаще всего несколько view не делается!!! и приводится к типу "имя класса"
        //Стандартная практика 1 XIB - 1 view
        let myAlertView = UINib(nibName: "Castom_Alert.xib", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CastomAlert
        myAlertView.backgroundColor = .cyan
        myAlertView.alpha = 0.8
        return myAlertView
        //функция возвращает объект нашего типа!!!
    }
    
    func addAlert(message: String, alert: CastomAlert){
        lable = UILabel.init()
        if let alertLable = lable {
            alertLable.text = message
            alertLable.textColor = colorText
            //длина lable по длине текста
            alertLable.sizeToFit()
            alertLable.frame.size.height = heightText
            alertLable.frame.origin.x = (alert.frame.width/2-(alertLable.frame.size.width/2))
            alertLable.frame.origin.y = top
            alert.addSubview(alertLable)
        }
    }
    
    func addOkAlertBtn(title: String, alert: CastomAlert, myFuncOK: (()->Void)?){
        if lable == nil {
            alert.superview?.removeFromSuperview()
            return
        } else {
            okBtn = MyBtn.init()
            if let button = okBtn {
                button.backgroundColor = UIColor.orange
                button.setTitle(title, for: .normal)
                button.titleLabel?.sizeToFit()
                button.frame.size.width = button.titleLabel?.frame.size.width ?? okBtnWidth
                button.frame.size.height = button.frame.size.width
                button.layer.cornerRadius = (button.frame.size.height)/2
                if cancelBtn == nil {
                    button.frame.origin.x = (alert.frame.width/2-(button.frame.size.width/2))
                    button.frame.origin.y = (alert.frame.height/2)-(button.frame.size.height/2)
                } else {
                    guard let buttonCancel = cancelBtn else {return}
                    buttonCancel.frame.origin.x = (alert.frame.width/2-(buttonCancel.frame.size.width/2))
                    buttonCancel.frame.origin.y = (alert.frame.height/2)-(buttonCancel.frame.size.height/2)+buttonCancel.frame.size.height
                    button.frame.origin.x = (alert.frame.width/2-(button.frame.size.width/2))
                    button.frame.origin.y = (alert.frame.height/2)-(button.frame.size.height/2)-button.frame.size.height
                }
                button.void = myFuncOK
                button.alert = alert
                button.addTarget(self, action: #selector(btnclicOk(_:)), for: .touchUpInside)
                alert.addSubview(button)}
        }
    }
    
    @objc func btnclicOk(_ sender: MyBtn) {
        guard let action = sender.void else {return}
        action()
        sender.alert?.removeFromSuperview()
    }
    
    func addCancseAlertBtn(title: String, alert: CastomAlert, cancelAlertView: UIView){
        cancelBtn = MyBtn.init()
        if let button = cancelBtn {
            button.backgroundColor = .green
            button.setTitle(title, for: .normal)
            button.titleLabel?.sizeToFit()
            button.frame.size.width = button.titleLabel?.frame.size.width ?? cancelBtnWidth
            button.frame.size.height = button.frame.size.width
            button.layer.cornerRadius = (button.frame.size.height)/2
            if okBtn == nil {
                button.frame.origin.x = (alert.frame.width/2-(button.frame.size.width/2))
                button.frame.origin.y = (alert.frame.height/2)-(button.frame.size.height/2)
            } else {
                guard let buttonOk = okBtn else {return}
                buttonOk.frame.origin.x = (alert.frame.width/2-(buttonOk.frame.size.width/2))
                buttonOk.frame.origin.y = (alert.frame.height/2)-(buttonOk.frame.size.height/2)-buttonOk.frame.size.height
                button.frame.origin.x = (alert.frame.width/2-(button.frame.size.width/2))
                button.frame.origin.y = (alert.frame.height/2)-(button.frame.size.height/2)+button.frame.size.height
            }
            button.myView = cancelAlertView
            button.alert = alert
            button.addTarget(self, action: #selector(btnclicCancel(_:)), for: .touchUpInside)
            alert.addSubview(button)}
    }
    @objc func btnclicCancel(_ sender: MyBtn) {
        sender.myView?.backgroundColor = backgroundColorCancelBtn
        sender.alert?.removeFromSuperview()
    }
}

