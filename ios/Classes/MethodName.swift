//
//  MethodName.swift
//  Pods
//
//  Created by D1MACBOOKAIR on 26/6/2569 BE.
//


enum MethodName: String {
    
    case getPlatformVersion = "GET_PLATFORM_VERSION"
    case requestPermissions = "REQUEST_PERMISSIONS"
    case readyToUsed = "READY_TO_USED"
    
    case openLibs = "OPEN_LIBS"
    case updateLicenseFile = "UPDATE_LICENSE_FILE"
    
    case findReader = "FIND_READER"
    
    /// ios platform
    case setReaderType = "SET_READER_TYPE"
    case stopFindReader = "STOP_FIND_READER"
    case getReaderList = "READER_LIST"
    
    case selectReader = "SELECT_READER"
    case deselectReader = "DESELECT_READER"
    
    case connectedCard = "CONNECTED_CARD"
    case disconnectedCard = "DISCONNECTED_CARD"
    
    case closedLibs = "CLOSED_LIBS"
    case getLicenseInfo = "GET_LICENSE_INFO"
    case getReaderInfo = "GET_READER_INFO"
    case getSoftwareInfo = "GET_SOFTWARE_INFO"
    
    case idCardNumber = "ID_CARD_NUMBER"
    case idCardText = "ID_CARD_TEXT"
    case icCardTextWithOptions = "ID_CARD_TEXT_WITH_OPTIONS"
    case idCardPhoto = "ID_CARD_PHOTO"
    
    case cardStatus = "CARD_STATUS"
    
    
}
