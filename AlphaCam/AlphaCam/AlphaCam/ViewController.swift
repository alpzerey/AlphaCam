//
//  ViewController.swift
//  AlphaCam
//
//  Created by Alp Zerey on 10.03.2019.
//  Copyright © 2019 Alp Zerey. All rights reserved.
//
import UIKit
import AVFoundation
import Photos

let WitePin = "WitePin"
let WitePinFilter = CIFilter(name: "CIWhitePointAdjust")

let BlendFill = "BlendFill"
let BlendFillFilter = CIFilter(name: "CIHardLightBlendMode")

let ColorNatural = "Color Natural"
let ColorNaturalEffectFilter = CIFilter(name: "CIPhotoEffectFade")


let Trans = "Trans"
let TransFilter = CIFilter(name: "CIPhotoEffectTransfer")

let MonoZero = "Mono Zero"
let MonoZeroEffectFilter = CIFilter(name: "CIMaximumComponent")

let NoiseKiller = "Noise Killer"
let NoiseKillerFilter = CIFilter(name: "CINoiseReduction", parameters: ["inputNoiseLevel" : 0.5,"inputSharpness" : 1])

let Vibrance = "Vibrance"
let VibranceFilter = CIFilter(name: "CIVibrance" , parameters:["inputAmount" : 1.5])

let MedianFilter = "Median Filter"
let MedianFilterFilter = CIFilter(name: "CIMedianFilter")

let Chrome = "Chrome"
let ChromeFilter = CIFilter(name: "CIPhotoEffectChrome")


let MonoBluean = "Mono Bluean"
let BlueanMonoFilter = CIFilter(name: "CIFalseColor" , parameters : ["inputColor0" : CIColor(red: 0.1,green: 0.2,blue: 0.3),"inputColor1":CIColor(red: 1,green: 1,blue: 1)])

let LSD = "LSD"
let LSDFilter = CIFilter(name: "CISRGBToneCurveToLinear")

let MonoGram = "Mono Gram"
let MonoGramFilter = CIFilter(name: "CIPhotoEffectMono")

let Instant = "Instant"
let InstantFilter = CIFilter(name: "CIPhotoEffectInstant")

let MonoFoir = "Mono Foir"
let MonoFoirFilter = CIFilter(name: "CIPhotoEffectNoir")

let GreenPan = "GreenPan"
let GreenPanFilter = CIFilter(name: "CIPhotoEffectProcess")

let OldFilter = "Old Filter"
let OldFilterFilter = CIFilter(name: "CISepiaTone" , parameters :["inputIntensity": 0.5 ])


let FlowerCut = "Flower Cut"
let FlowerCutFilter = CIFilter(name: "CIHueAdjust" , parameters : ["inputAngle":50])

let VintageCorp = "Vintage Corp"
let VintageCorpFilter = CIFilter(name: "CIColorMatrix", parameters : ["inputRVector" : CIVector(x: 1.028, y: -0.029, z: 0.21, w: 0),"inputGVector" : CIVector(x: 0.209, y: 0.954, z: -0.16, w: 0),"inputBVector" : CIVector(x: -0.237, y: 0.075, z: 0.949, w: 0),"inputAVector" : CIVector(x: 0, y: 0, z: 0, w: 0.5),"inputBiasVector" : CIVector(x: 0, y: 0, z: 0, w: 0)])

let MonoIce = "MonoIce"
let MonoIceFilter = CIFilter(name: "CIMinimumComponent")


let Filters = [
    WitePin: WitePinFilter,
    ColorNatural: ColorNaturalEffectFilter,
    Trans: TransFilter,
    MonoZero: MonoZeroEffectFilter,
    NoiseKiller: NoiseKillerFilter,
    Vibrance: VibranceFilter,
    MedianFilter: MedianFilterFilter,
    Chrome: ChromeFilter,
    MonoBluean: BlueanMonoFilter,
    LSD:LSDFilter,
    MonoGram:MonoGramFilter,
    Instant:InstantFilter,
    MonoFoir:MonoFoirFilter,
    GreenPan:GreenPanFilter,
    FlowerCut:FlowerCutFilter,
    VintageCorp:VintageCorpFilter,
    MonoIce:MonoIceFilter,
    OldFilter:OldFilterFilter,
    BlendFill: BlendFillFilter
    //Karts:KartsFilter
]

let FilterNames = [String].init(Filters.keys).sorted()


class ViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //let optionsPanel = optionsView()
    let filterViewController = filterView()
    override var prefersStatusBarHidden: Bool { return true }
    var myFrameViewWidth = 0.0
    var myFrameViewHeight = 0.0
    
    var KameraView = UIView()
    var realTimeView = UIView()
    var snapPicView = UIImageView()
    var popupView = UIView()
    var popupLabel = UILabel()
    var settingsPanel = UIView()
    var settingsPanelBlur = UIView()
    var centikBlur = UIView()
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var backCameraInput: AVCaptureInput?
    
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureInput?
    
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    let filtersControl = UISegmentedControl(items: FilterNames)
    let context = CIContext()
    var filteredImage = UIImageView()
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var changedFilter : Bool = false
    
    var userSayWait: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var simplemyImage = UIImage(named : "simpleImage.JPG")
    
    let shutterImage = UIImage(named: "shutterImage.JPG")
    let flashOffImage = UIImage(named: "FlashOff.JPG")
    let flashOnImage = UIImage(named: "FlashOn.JPG")
    let flipCapImage = UIImage(named: "TurnCam.JPG")
    let backButtonImage = UIImage(named: "back.JPG")
    let saveImageImage = UIImage(named:"Save.JPG")
    let btnBlurImage = UIImage(named: "Bokeh.JPG")
    let btnExpoImage = UIImage(named: "nightico.JPG")
    let btnSharpenImage = UIImage(named: "Sharp.JPG")
    let btnGamma = UIImage(named: "Gamma.JPG")
    let btnVignette = UIImage(named:"Vignette.JPG")
    let btnFilterOnOffImage = UIImage(named:"filter.JPG")
    let offText = UILabel()
    
    var blurImage = UIImage(named: "blurImage.JPG")
    var colorBlendImage = UIImage(named: "blendOldHori.JPG")
    
    let button = UIButton()
    let buttonFlash = UIButton()
    let buttonCameraReverse = UIButton()
    let buttonBack = UIButton()
    let buttonSavePicture = UIButton()
    let buttonFilterView = UIButton()
    let buttonVignette = UIButton()
    let buttonBlur = UIButton()
    let buttonExpo = UIButton()
    let buttonSharpen = UIButton()
    let buttonGamma = UIButton()
    
    var flashMode = AVCaptureDevice.FlashMode.off
    var phototake = false
    
    let filterAddGamma = CIFilter(name: "CIGammaAdjust")
    var filterGammaOn = false
    var gammaValue = Float()
    var gammaLabel = UILabel()
    
    let filterAdd = CIFilter(name: "CIVignetteEffect")
    var filterTwoOn = false
    var vignetteValue = Float()
    var vignetteLabel = UILabel()
    
    let filterAddBlur = CIFilter(name: "CIMaskedVariableBlur")
    var filterBlurOn = false
    var blurValue = Float()
    var blurLabel = UILabel()
    
    var expoValue = Float()
    let filterExposure = CIFilter(name: "CIExposureAdjust")
    var exposureOn = false
    var expesureLabel = UILabel()
    
    let filterSharpen = CIFilter(name: "CISharpenLuminance")
    var filterSharpenOn = false
    var sharpValue = Float()
    var SharpLabel = UILabel()
    
    var takeShotShapeLayer = CAShapeLayer()
    var circularPath = UIBezierPath()
    
    var expoSlider : UISlider!
    var sharpSlider : UISlider!
    var blurSlider : UISlider!
    var vignetteSlider : UISlider!
    var gammaSlider : UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simplemyImage = resizeImage(image: simplemyImage!, isFlip: false)
        expoValue = 0.0
        sharpValue = 0.0
        blurValue = 0.0
        vignetteValue = 0.0
        gammaValue = 0.75
        myFrameViewWidth = Double(view.frame.width)
        myFrameViewHeight = Double(view.frame.height)
        colorBlendImage = resizeImage(image: colorBlendImage!,isFlip: true)
        blurImage = resizeImage(image: blurImage!,isFlip: true)
        viewsCreate()
        gestureCreate()
        filtersControl.selectedSegmentIndex = 0
        
        buttonsCreate()
        setupDevice()
        setupInputOutput()
        
        
        AddLoadButtons()
        self.view.addSubview(KameraView)
        
        
        
        
    }
    
    func resizeImage(image: UIImage , isFlip: Bool) -> UIImage
    {
        
        
        UIGraphicsBeginImageContext(CGSize(width: 720, height: 1280))
        
        image.draw(in: CGRect(x: 0, y: 0, width: 720, height: 1280))
        
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if(isFlip)
        {
        newImage = flipImage(image: newImage!)
        }
            return newImage!
        
    }
    func sliderResizeImage(image: UIImage , Imagesize : Int) -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: Imagesize, height: Imagesize))
        
        image.draw(in: CGRect(x: 0, y: 0, width: Imagesize, height: Imagesize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    
    func gestureCreate()
    {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        KameraView.addGestureRecognizer(upSwipe)
        KameraView.addGestureRecognizer(downSwipe)
        KameraView.addGestureRecognizer(leftSwipe)
        KameraView.addGestureRecognizer(rightSwipe)
        
    }
    
    func viewsCreate()
    {
        KameraView = UIView(frame: CGRect(x: 0, y: 0, width: myFrameViewWidth, height: myFrameViewHeight))
        filteredImage = UIImageView(frame: CGRect(x: 0, y: 0, width: myFrameViewWidth, height: myFrameViewHeight))
        realTimeView = UIImageView(frame: CGRect(x: 0, y: 0, width: myFrameViewWidth, height: myFrameViewHeight))
        snapPicView =  UIImageView(frame: CGRect(x: 0, y: 0, width: myFrameViewWidth, height: myFrameViewHeight))
        
        
        let blurEfect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        popupView = UIVisualEffectView(effect: blurEfect)
        popupView.frame = CGRect(x: view.frame.width/2-50, y: 50, width: 100, height: 25)
        popupLabel.frame = CGRect(x: view.frame.width/2-50, y: 50, width: 100, height: 25)
        popupView.layer.cornerRadius = 5
        popupView.layer.masksToBounds = true
        
        settingsPanelBlur = UIVisualEffectView(effect: blurEfect)
        //settingsPanel.backgroundColor = .black
        settingsPanelBlur.frame = CGRect(x: -((myFrameViewWidth/3.5)+98), y: myFrameViewHeight/2-150, width: ((myFrameViewWidth/3.5)+100), height: 235)
        settingsPanelBlur.layer.cornerRadius = 5
        settingsPanelBlur.layer.masksToBounds = true
        
        centikBlur = UIVisualEffectView(effect: blurEfect)
        centikBlur.frame = CGRect(x: settingsPanelBlur.frame.width-7, y: settingsPanelBlur.frame.height/2-15, width: 14, height: 30)
        centikBlur.layer.cornerRadius = 5
        centikBlur.layer.masksToBounds = true
        
        snapPicView.isHidden = true
        KameraView.backgroundColor = .black
        KameraView.addSubview(filteredImage)
        KameraView.insertSubview(snapPicView, at: 1)
        userSayWait.center = self.view.center
        userSayWait.hidesWhenStopped = true
        userSayWait.style = .whiteLarge
        snapPicView.addSubview(userSayWait)
        
        
    }
    
    
    
    //Etkileşim tuşlarının oluşturulması
    func buttonsCreate()
    {
        
        
        settingsPanel.frame = CGRect(x: -((myFrameViewWidth/3.5)+98), y: myFrameViewHeight/2-150, width: ((myFrameViewWidth/3.5)+100), height: 235)
        
        
        
        button.frame = CGRect(x: myFrameViewWidth/2-25, y: myFrameViewHeight-80, width: 50, height: 50)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.cornerRadius = min(button.frame.width, button.frame.height) / 2
        
        circularPath = UIBezierPath(arcCenter: button.center, radius:35, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        takeShotShapeLayer.path = circularPath.cgPath
        takeShotShapeLayer.fillColor = UIColor.lightGray.cgColor
        takeShotShapeLayer.opacity = 0.8
        
        buttonFlash.frame = CGRect(x: myFrameViewWidth-55, y: myFrameViewHeight-60, width: 35, height: 35)
        buttonFlash.setImage(flashOffImage, for: .normal)
        buttonFlash.addTarget(self, action: #selector(buttonActionFlash), for: .touchUpInside)
        buttonFlash.layer.cornerRadius = min(buttonFlash.frame.width, buttonFlash.frame.height) / 2
        buttonFlash.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        buttonFlash.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        buttonFlash.layer.shadowOpacity = 1.0
        buttonFlash.layer.shadowRadius = 2.5
        buttonFlash.layer.masksToBounds = false
        
        
        buttonCameraReverse.frame = CGRect(x: myFrameViewWidth-50, y: 10, width: 35, height: 35)
        buttonCameraReverse.setImage(flipCapImage, for: .normal)
        buttonCameraReverse.addTarget(self, action: #selector(buttonActionReverse), for: .touchUpInside)
        buttonCameraReverse.layer.cornerRadius = min(buttonCameraReverse.frame.width, buttonCameraReverse.frame.height) / 2
        buttonCameraReverse.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        buttonCameraReverse.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        buttonCameraReverse.layer.shadowOpacity = 1.0
        buttonCameraReverse.layer.shadowRadius = 2.5
        buttonCameraReverse.layer.masksToBounds = false
        
        buttonBack.frame = CGRect(x: 20, y: myFrameViewHeight-50, width: 35, height: 35)
        buttonBack.setImage(backButtonImage, for: .normal)
        buttonBack.addTarget(self, action: #selector(buttonActionBack), for: .touchUpInside)
        buttonBack.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        buttonBack.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        buttonBack.layer.shadowOpacity = 1.0
        buttonBack.layer.shadowRadius = 2.5
        buttonBack.layer.masksToBounds = false
        
        buttonSavePicture.frame = CGRect(x: myFrameViewWidth-40, y: myFrameViewHeight-50, width: 35, height: 35)
        buttonSavePicture.setImage(saveImageImage, for: .normal)
        buttonSavePicture.addTarget(self, action: #selector(buttonActionPicSave), for: .touchUpInside)
        buttonSavePicture.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor
        buttonSavePicture.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        buttonSavePicture.layer.shadowOpacity = 1.0
        buttonSavePicture.layer.shadowRadius = 2.5
        buttonSavePicture.layer.masksToBounds = false
        
        
        buttonFilterView.frame = CGRect(x: 20, y: myFrameViewHeight-60, width: 35, height: 35)
        buttonFilterView.setImage(btnFilterOnOffImage, for: .normal)
        buttonFilterView.addTarget(self, action: #selector(buttonActionFilter), for: .touchUpInside)
        
        buttonVignette.frame = CGRect(x: 20, y: 10, width: 35, height: 35)
        buttonVignette.setImage(btnVignette, for: .normal)
        buttonVignette.addTarget(self, action: #selector(buttonVignetteAction), for: .touchUpInside)
        vignetteLabel = UILabel(frame: CGRect(x: 60, y: 10, width: 100, height: 35))
        vignetteLabel = labels(label: vignetteLabel)
        vignetteLabel.text = "Vignette Off"
        
        buttonBlur.frame = CGRect(x: 20, y: 55, width: 35, height: 35)
        buttonBlur.setImage(btnBlurImage, for: .normal)
        buttonBlur.addTarget(self, action: #selector(buttonBlurAction), for: .touchUpInside)
        blurLabel = UILabel(frame: CGRect(x: 60, y: 55, width: 100, height: 35))
        blurLabel = labels(label: blurLabel)
        blurLabel.text = "Bokeh Off"
        
        buttonExpo.frame = CGRect(x: 20, y: 100, width: 35, height: 35)
        buttonExpo.setImage(btnExpoImage, for: .normal)
        buttonExpo.addTarget(self, action: #selector(buttonExpoAction), for: .touchUpInside)
        expesureLabel = UILabel(frame: CGRect(x: 60, y: 100, width: 100, height: 35))
        expesureLabel = labels(label: expesureLabel)
        expesureLabel.text = "Exposure Auto"
        
        buttonSharpen.frame = CGRect(x: 20, y: 145, width: 35, height: 35)
        buttonSharpen.setImage(btnSharpenImage, for: .normal)
        buttonSharpen.addTarget(self, action: #selector(buttonSharpenAction), for: .touchUpInside)
        SharpLabel = UILabel(frame: CGRect(x: 60, y: 145, width: 100, height: 35))
        SharpLabel = labels(label: SharpLabel)
        SharpLabel.text = "Sharp Auto"
        
        buttonGamma.frame = CGRect(x: 20, y: 190, width: 35, height: 35)
        buttonGamma.setImage(btnGamma, for: .normal)
        buttonGamma.addTarget(self, action: #selector(buttonGammaAction), for: .touchUpInside)
        gammaLabel = UILabel(frame: CGRect(x: 60, y: 190, width: 100, height: 35))
        gammaLabel = labels(label: gammaLabel)
        gammaLabel.text = "Gamma Auto"
        
        vignetteSlider = UISlider(frame: CGRect(x: 90, y: 10, width: myFrameViewWidth/3.5, height: 35))
        vignetteSlider.minimumValue = 0.0
        vignetteSlider.maximumValue = 2.0
        vignetteSlider.value = 0
        vignetteSlider.tintColor = UIColor.white
        vignetteSlider.maximumTrackTintColor = UIColor.white
        vignetteSlider.setThumbImage(sliderResizeImage(image: btnVignette!,Imagesize: 35), for: .normal)
        vignetteSlider.isContinuous = true
        vignetteSlider.addTarget(self, action: #selector(sliderVigChange(sender:)), for: .valueChanged)
        
        blurSlider = UISlider(frame: CGRect(x: 90, y: 55, width: myFrameViewWidth/3.5, height: 35))
        blurSlider.minimumValue = 0.0
        blurSlider.maximumValue = 10.0
        blurSlider.value = 0
        blurSlider.tintColor = UIColor.white
        blurSlider.maximumTrackTintColor = UIColor.white
        blurSlider.setThumbImage(sliderResizeImage(image: btnBlurImage!,Imagesize: 35), for: .normal)
        blurSlider.isContinuous = true
        blurSlider.addTarget(self, action: #selector(sliderBlurChange(sender:)), for: .valueChanged)
        
        expoSlider = UISlider(frame: CGRect(x: 90, y: 100, width: myFrameViewWidth/3.5, height: 35))
        //expoSlider.center = view.center
        expoSlider.minimumValue = -7.0
        expoSlider.maximumValue = 7.0
        expoSlider.value = 0
        expoSlider.tintColor = UIColor.white
        expoSlider.maximumTrackTintColor = UIColor.white
        expoSlider.setThumbImage(sliderResizeImage(image: btnExpoImage!,Imagesize: 35), for: .normal)
        expoSlider.isContinuous = true
        expoSlider.addTarget(self, action: #selector(sliderExpoChange(sender:)), for: .valueChanged)
        
        sharpSlider = UISlider(frame: CGRect(x: 90, y: 145, width: myFrameViewWidth/3.5, height: 35))
        sharpSlider.minimumValue = -10.0
        sharpSlider.maximumValue = 10.0
        sharpSlider.value = 0
        sharpSlider.tintColor = UIColor.white
        sharpSlider.maximumTrackTintColor = UIColor.white
        sharpSlider.setThumbImage(sliderResizeImage(image: btnSharpenImage!,Imagesize: 35), for: .normal)
        sharpSlider.isContinuous = true
        sharpSlider.addTarget(self, action: #selector(sliderSharpChange(sender:)), for: .valueChanged)
        
        
        gammaSlider = UISlider(frame: CGRect(x: 90, y: 190, width: myFrameViewWidth/3.5, height: 35))
        gammaSlider.minimumValue = -1.0
        gammaSlider.maximumValue = 10.0
        gammaSlider.value = 0.75
        gammaSlider.tintColor = UIColor.white
        gammaSlider.maximumTrackTintColor = UIColor.white
        gammaSlider.setThumbImage(sliderResizeImage(image: btnGamma!,Imagesize: 35), for: .normal)
        gammaSlider.isContinuous = true
        gammaSlider.addTarget(self, action: #selector(sliderGammaChange(sender:)), for: .valueChanged)
        
       
        
        
    }
    func labels(label : UILabel)->UILabel
    {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
        
    }
    
    
    
    //Butonların Eklenmesi
    func AddLoadButtons()
    {
        filterSimple()
        KameraView.addSubview(filterViewController.createView())
        KameraView.layer.addSublayer(takeShotShapeLayer)
        KameraView.addSubview(button)
        KameraView.addSubview(buttonFlash)
        KameraView.addSubview(buttonCameraReverse)
        KameraView.addSubview(buttonFilterView)
        KameraView.addSubview(buttonBack)
        KameraView.addSubview(buttonSavePicture)
        
        
        KameraView.addSubview(settingsPanelBlur)
        KameraView.addSubview(settingsPanel)
        //Ayar paneli
        settingsPanel.addSubview(buttonSharpen)
        settingsPanel.addSubview(SharpLabel)
        settingsPanel.addSubview(buttonVignette)
        settingsPanel.addSubview(vignetteLabel)
        
        settingsPanel.addSubview(buttonBlur)
        settingsPanel.addSubview(blurLabel)
        settingsPanel.addSubview(buttonGamma)
        settingsPanel.addSubview(gammaLabel)
        settingsPanel.addSubview(buttonExpo)
        settingsPanel.addSubview(expesureLabel)
        settingsPanel.addSubview(expoSlider)
        settingsPanel.addSubview(sharpSlider)
        settingsPanel.addSubview(blurSlider)
        settingsPanel.addSubview(vignetteSlider)
        settingsPanel.addSubview(gammaSlider)
        settingsPanel.addSubview(centikBlur)
        //Ayar paneli son
        //popup view ekleme
        KameraView.addSubview(popupView)
        popupLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        popupLabel.textColor = .white
        popupLabel.textAlignment = .center
        KameraView.addSubview(popupLabel)
        //popupview son
        
        popupView.alpha = 0
        popupLabel.alpha = 0
        expoSlider.alpha = 0
        sharpSlider.alpha = 0
        blurSlider.alpha = 0
        vignetteSlider.alpha = 0
        buttonBack.isHidden = true
        buttonSavePicture.isHidden = true
        gammaSlider.alpha = 0
        
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        //print("Button tapped")
        captureImage {(image, error) in
            guard let image = image else {print(error ?? "Image capture error")
                return
                
            }
            
            self.snapPicView.image = image
            
            self.afterTakeAPicture()
            
        }
        
        
    }
    func popupHide()
    {
        
        popupView.alpha = 1
        popupLabel.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 0
            self.popupLabel.alpha = 0
        }){(finished) in
            self.popupView.isHidden = finished
            self.popupLabel.isHidden = finished
            
        }
        
    }
    
    func popupShow(text : String)
    {
        popupLabel.text = text
        self.popupView.isHidden = false
        self.popupLabel.isHidden = false
        popupView.alpha = 0
        popupLabel.alpha = 0
        UIView.animate(withDuration: 1.0) {
            self.popupLabel.alpha = 1
            self.popupView.alpha = 1
            self.popupHide()
        }
        
    }
    
    func setPanelHide()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsPanel.frame.origin.x = CGFloat(-((self.myFrameViewWidth/3.5)+98))
            self.settingsPanelBlur.frame.origin.x = CGFloat(-((self.myFrameViewWidth/3.5)+98))
        }){(finished) in
            self.popupShow(text: "Hide Settings")
            
        }
    }
    func setPanelShow()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsPanel.frame.origin.x = -10
            self.settingsPanelBlur.frame.origin.x = -10
        }){(finished) in
            self.popupShow(text: "Show Settings")
            
        }
    }
    
    
    func afterTakeAPicture()
    {
        snapPicView.isHidden = false
        buttonBack.isHidden = false
        buttonSavePicture.isHidden = false
        
        button.isHidden = true
        buttonFlash.isHidden = true
        buttonCameraReverse.isHidden = true
        buttonFilterView.isHidden = true
        
        filterViewController.hideShowview(hide : true)
        takeShotShapeLayer.isHidden = true
        phototake = true
        
        
        settingsPanel.isHidden = true
        settingsPanelBlur.isHidden = true
    }
    
    
    
    
    @objc func buttonActionBack(sender: UIButton!)
    {
        snapPicView.isHidden = true
        button.isHidden = false
        buttonFlash.isHidden = false
        buttonCameraReverse.isHidden = false
        buttonFilterView.isHidden = false
        buttonBack.isHidden = true
        buttonSavePicture.isHidden = true
        phototake = false
        
       
        takeShotShapeLayer.isHidden = false
        settingsPanel.isHidden = false
        settingsPanelBlur.isHidden = false
    }
    
    
    
    @objc func sliderVigChange(sender: UISlider!)
    {
        vignetteValue = sender.value
        popupShow(text: "Exposure : \(String(vignetteValue).prefix(4))")
        vignetteLabel.text = String(String(vignetteValue).prefix(4))
    }
    
    @objc func sliderExpoChange(sender: UISlider!)
    {
        expoValue = sender.value
        popupShow(text: "Exposure : \(String(expoValue).prefix(4))")
        expesureLabel.text = String(String(expoValue).prefix(4))
    }
    @objc func sliderSharpChange(sender: UISlider!)
    {
        sharpValue = sender.value
        popupShow(text: "Sharp : \(String(sharpValue).prefix(4))")
        SharpLabel.text = String(String(sharpValue).prefix(4))
    }
    @objc func sliderBlurChange(sender: UISlider!)
    {
        blurValue = sender.value
        popupShow(text: "Bokeh : \(String(blurValue).prefix(4))")
        blurLabel.text = String(String(blurValue).prefix(4))
    }
    @objc func sliderGammaChange(sender: UISlider!)
    {
        gammaValue = sender.value
        popupShow(text: "Gamma : \(String(gammaValue).prefix(4))")
        gammaLabel.text = String(String(gammaValue).prefix(4))
    }
    
    @objc func buttonVignetteAction(sender: UIButton!)
    {
        filterTwoOn = !filterTwoOn
        if(filterTwoOn){
            popupShow(text: "Vignette ON!")
            vignetteSlider.alpha = 1
            vignetteLabel.text = String(String(vignetteValue).prefix(4))
        }
        else{
            popupShow(text: "Vignette OFF!")
            vignetteSlider.alpha = 0
            vignetteLabel.text = "Vignette OFF"
        }
        
    }
    
    @objc func buttonGammaAction(sender: UIButton!)
    {
        filterGammaOn = !filterGammaOn
        if(filterGammaOn){ buttonGamma.setImage(btnGamma, for: .normal)
            popupShow(text: "Gamma ON!")
            gammaLabel.text = String(gammaValue)
            gammaSlider.alpha = 1
        }
        else{buttonGamma.setImage(btnGamma, for: .normal)
            popupShow(text: "Gamma Auto!")
            gammaLabel.text = "Gamma Auto"
            gammaSlider.alpha = 0
        }
        
    }
    
    @objc func buttonBlurAction(sender: UIButton!)
    {
        filterBlurOn = !filterBlurOn
        if(filterBlurOn){
            popupShow(text: "Bokeh ON!")
            blurLabel.text = String(blurValue)
            blurSlider.alpha = 1
        }
        else{
            popupShow(text: "Bokeh OFF!")
            blurLabel.text = "Bokeh OFF!"
            blurSlider.alpha = 0
        }
    }
    @objc func buttonExpoAction(sender: UIButton!)
    {
        exposureOn = !exposureOn
        if(exposureOn){
            popupShow(text: "Exposure ON!")
            expesureLabel.text = String(expoValue)
            expoSlider.alpha = 1
        }
        else{
            popupShow(text: "Exposure Auto!")
            expesureLabel.text = "Exposure Auto"
            expoSlider.alpha = 0
        }
        
    }
    
    @objc func buttonSharpenAction(sender: UIButton!)
    {
        filterSharpenOn = !filterSharpenOn
        if(filterSharpenOn){
            
            sharpSlider.alpha = 1
            popupShow(text: "Sharpen ON!")
            SharpLabel.text = String(sharpValue)
        }
        else{
            sharpSlider.alpha = 0
            popupShow(text: "Sharpen Auto!")
            SharpLabel.text = "Sharpen Auto"
        }
        
    }
    
    //Kamera değiştirme butonu
    @objc func buttonActionReverse(sender: UIButton!)
    {
        changeCamPos()
        
    }
    
    func changeCamPos()
    {
        if(currentCamera == frontCamera)
        {
            popupShow(text: "Back Cam!")
            changeCameraBack()
            
            
        }else{
            popupShow(text: "Front Cam!")
            changeCameraFront()
        }
        
    }
    
    
    //Picture Save
    @objc func buttonActionPicSave(sender:UIButton!)
    {
        
        try? PHPhotoLibrary.shared().performChangesAndWait
        {
            self.popupShow(text: "Saving..")
            self.userSayWait.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            PHAssetChangeRequest.creationRequestForAsset(from: self.snapPicView.image!)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:
                {
                self.userSayWait.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                    self.popupShow(text: "Saved..")
                    
            })
            
            
        }
    }
    
    
    //Flash Button
    @objc func buttonActionFlash(sender:UIButton!)
    {
        //print("Tapped Flash")
        if self.flashMode == .on {
            self.flashMode = .off
            buttonFlash.setImage(flashOffImage, for: .normal)
            popupShow(text: "Flash OFF!")
            
        }
            
        else {
            self.flashMode = .on
            buttonFlash.setImage(flashOnImage, for: .normal)
            popupShow(text: "Flash ON!")
        }
    }
    
    //Filters Button
    @objc func buttonActionFilter(sender : UIButton!)
    {
        
        filterViewController.hideShowviewToggle()
        
    }
    @objc func handleSwipe(sender: UISwipeGestureRecognizer)
    {
        if (sender.state == .ended && phototake == false)
        {
            switch sender.direction
            {
            case .up:
                filterViewController.hideShowview(hide: false)
                popupShow(text: "Filters Panel Show")
            case .down:
                filterViewController.hideShowview(hide: true)
                popupShow(text: "Filters Panel Hide")
            case .left:
                setPanelHide()
            case .right:
                setPanelShow()
            default:
                break
            }
            
            
        }
    }
    
    
    
    //filtre Ön izlemeleri
    func filterSimple()
    {
        
        for i in 0..<FilterNames.count{
            let filter = Filters[FilterNames[i]]
            let image = CIImage(image: simplemyImage!)
            let imageColorBlend = CIImage(image: colorBlendImage!)
            filter!!.setValue(image, forKey: kCIInputImageKey)
            if(FilterNames[i] == "BlendFill"){
                filter!!.setValue(imageColorBlend, forKey: "inputBackgroundImage")
            }
            let test = filter??.value(forKey: kCIOutputImageKey)
            let output1 = self.context.createCGImage(test! as! CIImage, from: (test! as AnyObject).extent)
            filterViewController.simpleImage.append(UIImage(cgImage: output1!))
            
            filterViewController.labels.append(FilterNames[i])
            
            
            
        }
    }
    
    
    //Aygıtların Eklenmesi
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = frontCamera
    }
    
    
    
    //Arka Kameraya geçme
    func changeCameraBack()
    {
        do{
            filteredImage.image = nil
            let inputs = captureSession.inputs as [AVCaptureInput]
            captureSession.removeInput(inputs[0])
            captureSession.beginConfiguration()
            captureSession.addInput(try AVCaptureDeviceInput(device: backCamera!))
            captureSession.commitConfiguration()
            currentCamera = backCamera
            
        }
        catch
        {
            print("hata Change Back")
        }
        
        
        
    }
    
    //Ön kameraya geçme
    func changeCameraFront()
    {
        do{
            filteredImage.image = nil
            let inputs = captureSession.inputs as [AVCaptureInput]
            captureSession.removeInput(inputs[0])
            captureSession.beginConfiguration()
            captureSession.addInput(try AVCaptureDeviceInput(device: frontCamera!))
            captureSession.commitConfiguration()
            currentCamera = frontCamera
            
            
        }
        catch
        {
            print("hata Change Front")
        }
        
        
    }
    
    
    //Giriş çıkış değerlerinin ayarlanması
    func setupInputOutput() {
        do {
            
            setupCorrectFramerate(currentCamera: currentCamera!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            
            
            if captureSession.canAddInput(captureDeviceInput)
            {
                captureSession.addInput(captureDeviceInput)
            }
            
            
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput)
            {
                captureSession.addOutput(videoOutput)
            }
            self.photoOutput = AVCapturePhotoOutput()
            
            
            
            self.photoOutput!.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            photoOutput?.isHighResolutionCaptureEnabled = true
            
            if captureSession.canAddOutput(self.photoOutput!)
            {
                captureSession.addOutput(self.photoOutput!)
                
            }
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    
    //FRame rate düzeltme
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
            let frameRates = ranges[0]
            
            do {
                //set to 240fps - available types are: 30, 60, 120 and 240 and custom
                // lower framerates cause major stuttering
                if frameRates.maxFrameRate == 30 {
                    try currentCamera.lockForConfiguration()
                    currentCamera.activeFormat = vFormat as AVCaptureDevice.Format
                    //for custom framerate set min max activeVideoFrameDuration to whatever you like, e.g. 1 and 180
                    currentCamera.activeVideoMinFrameDuration = frameRates.minFrameDuration
                    currentCamera.activeVideoMaxFrameDuration = frameRates.maxFrameDuration
                }
            }
            catch {
                print("Could not set active format")
                print(error)
            }
        }
    }
    
    
    func addFilter(buffer : CMSampleBuffer)->UIImage
    {
        
        let filter = Filters[FilterNames[filtersControl.selectedSegmentIndex]]
        
        
        
        
        
        
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        var cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        if(currentCamera == frontCamera)
        {
            cameraImage = cameraImage.oriented(.upMirrored)
            
        }
        
        filter??.setValue(cameraImage, forKey: kCIInputImageKey)
        var cgImage = self.context.createCGImage((filter??.outputImage!)!, from: cameraImage.extent)!
        
        if(exposureOn)
        {
            cgImage = self.context.createCGImage(self.expoApply(self.filterExposure, for: CIImage(cgImage: cgImage)), from: cameraImage.extent)!
        }
        
        
        if(filterTwoOn)
        {
            cgImage = self.context.createCGImage(self.apply(self.filterAdd, for: CIImage(cgImage: cgImage)), from: cameraImage.extent)!
        }
        if(filterBlurOn)
        {
            
            cgImage = self.context.createCGImage(self.blurapply(self.filterAddBlur, for: CIImage(cgImage: cgImage)), from: cameraImage.extent)!
            
        }
        if(filterSharpenOn)
        {
            cgImage = self.context.createCGImage(self.sharpApply(self.filterSharpen, for: CIImage(cgImage: cgImage)), from: cameraImage.extent)!
        }
        if(filterGammaOn)
        {
            cgImage = self.context.createCGImage(self.GammaApply(self.filterAddGamma, for: CIImage(cgImage: cgImage)), from: cameraImage.extent)!
        }
        
        
        
        return UIImage(cgImage: cgImage)
    }
    
    //Gamma add
    func GammaApply(_ filter: CIFilter?, for image: CIImage ) -> CIImage
    {
        
        
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(gammaValue, forKey: "inputPower")
        let filteredImage = filter.value(forKey: kCIOutputImageKey)
        
        
        
        return filteredImage as! CIImage
    }
    
    
    //Sharpen add
    func sharpApply(_ filter: CIFilter?, for image: CIImage ) -> CIImage
    {
        
        
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(sharpValue, forKey: "inputSharpness")
        let filteredImage = filter.value(forKey: kCIOutputImageKey)
        
        
        
        return filteredImage as! CIImage
    }
    
    
    
    
    //Exposure add
    func expoApply(_ filter: CIFilter?, for image: CIImage ) -> CIImage
    {
    
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(self.expoValue, forKey: "inputEV")
        let filteredImage = filter.value(forKey: kCIOutputImageKey)
        
        return filteredImage as! CIImage
    }
    //Bokeh Blur
    func blurapply(_ filter: CIFilter?, for image: CIImage ) -> CIImage
    {
        
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIImage(image: blurImage!), forKey: "inputMask")
        filter.setValue(blurValue, forKey: kCIInputRadiusKey)
        let filteredImage = filter.value(forKey: kCIOutputImageKey)
        
        return filteredImage as! CIImage
    }
    
    //vignette
    func apply(_ filter: CIFilter?, for image: CIImage) -> CIImage {
        
        
        let center = CIVector(x: (CGFloat(myFrameViewWidth/2+(myFrameViewWidth/2))), y: CGFloat(myFrameViewHeight/2+(myFrameViewWidth)))
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(myFrameViewHeight, forKey: kCIInputRadiusKey)
        filter.setValue(center, forKey: kCIInputCenterKey)
        filter.setValue(vignetteValue, forKey: kCIInputIntensityKey)
        let filteredImage = filter.value(forKey: kCIOutputImageKey)
        
        return filteredImage as! CIImage
    }
    
    
    
    
    
    //ön Kamera görüntüsü aynalama
    func flipImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            
            return image
        }
        let flippedImage = UIImage(cgImage: cgImage,scale: image.scale,orientation: .upMirrored)
        return flippedImage
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
                { (authorized) in
                    DispatchQueue.main.async
                        {
                            if authorized
                            {
                                self.setupInputOutput()
                            }
                    }
            })
        }
    }
    
    //Fotoğraf yakalama ayarları
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    //Yakalama çıkışı REaltime!
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        
        let image = self.addFilter(buffer: sampleBuffer)
        
        DispatchQueue.main.async {
            
            if(!self.phototake)
            {
                if(self.changedFilter != self.filterViewController.selectedFilter)
                {
                    self.changedFilter = self.filterViewController.selectedFilter
                    self.popupShow(text: FilterNames[self.filterViewController.indexFilter])
                    
                }
                 self.filtersControl.selectedSegmentIndex = self.filterViewController.indexFilter
                //RealTime aygıt görüntüsünün birimde aktarılması
                self.filteredImage.image = image
                
            }
            
        }
        
        
    }
    
    
}










extension ViewController: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?)
    {
        let filter = Filters[FilterNames[filtersControl.selectedSegmentIndex]]
        //connection.video
        
        
        if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            var image = CIImage(data: data) {
            if(currentCamera == frontCamera)
            {
                image = image.oriented(.leftMirrored)
            }
            else
            {
                image = image.oriented(.right)
            }
            filter??.setValue(image, forKey: kCIInputImageKey)
            
            var cgImage = self.context.createCGImage((filter??.outputImage!)!, from: image.extent)!
            
            if(filterTwoOn)
            {
                cgImage = self.context.createCGImage(self.apply(self.filterAdd, for: CIImage(cgImage: cgImage)), from: image.extent)!
            }
            if(filterBlurOn)
            {
                
                cgImage = self.context.createCGImage(self.blurapply(self.filterAddBlur, for: CIImage(cgImage: cgImage)), from: image.extent)!
                
            }
            if(exposureOn)
            {
                cgImage = self.context.createCGImage(self.expoApply(self.filterExposure, for: CIImage(cgImage: cgImage)), from: image.extent)!
            }
            
            if(filterSharpenOn)
            {
                cgImage = self.context.createCGImage(self.sharpApply(self.filterSharpen, for: CIImage(cgImage: cgImage)), from: image.extent)!
            }
            if(filterGammaOn)
            {
                cgImage = self.context.createCGImage(self.GammaApply(self.filterAddGamma, for: CIImage(cgImage: cgImage)), from: image.extent)!
            }
            self.photoCaptureCompletionBlock?(UIImage(cgImage: cgImage), nil)
            
    
        }
        
    }
}
