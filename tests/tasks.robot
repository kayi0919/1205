*** Settings ***
Documentation       Generate NEWS Title
Library            RPA.Browser.Selenium    
Library            RPA.Excel.Files
Library            RPA.HTTP
Library            Collections
Library            String
Library            OperatingSystem
Library            RPA.JSON


#1. 抓台北市一周預報 白天 
#　紀錄以下欄位
#　a. 日期 (如07/18星期二)
#  b. 預報 (如多雲午後短暫雷陣雨)
#  c. 氣溫 (28-35)
#  d. 產出excel



*** Tasks ***
Weather Prediction
    #test11111
    Open Website
    ${date_list} =    Collect Date
    Log    ${date_list}
    ${forecast_list}=    Collect Forecast
    Log    ${forecast_list}
    ${temp_list} =     Collect Temp
    Log    ${temp_list}
    Run Keyword And Ignore Error    Create Excel    /result1.xlsx    ${date_list}    ${forecast_list}    ${temp_list}
    Run Keyword And Ignore Error    Create Excel    /result/result1.xlsx    ${date_list}    ${forecast_list}    ${temp_list}
    Capture Page Screenshot    test.png



*** Keywords ***
Open Website
    Open Available Browser    https://www.cwa.gov.tw/V8/C/W/County/County.html?CID=63
Collect Date
    ${date_locator} =    Set Variable    //th[@scope='col']
    ${date_elements} =    Get WebElements    ${date_locator}
    ${date_list}=    Create List
    FOR    ${element}    IN    @{date_elements}
        ${date_text}    Get text    ${element}
        Append To List    ${date_list}    ${date_text}
    END
    
    [Return]    ${date_list}


Collect Forecast
    ${forecast_locator} =    Set Variable    //tr[@class='day']//span[@class='signal']/img
    ${forecast_elements}=    Get WebElements    ${forecast_locator}
    ${forecast_list}=    Create List
    FOR    ${forecast_element}    IN    @{forecast_elements}
        ${forecast_title}=    Get Element Attribute    ${forecast_element}    title
        Append To List    ${forecast_list}    ${forecast_title}
    END
    [Return]    ${forecast_list}
Collect Temp
    # 使用XPath來定位特定的<tr>元素
    ${temp_locator} =    Set Variable    //tr[@class='day']//p[@class='text-center']
    # 獲取<tr class="day">中所有的數值
    ${temp_elements}=    Get WebElements    ${temp_locator}
    ${temp_list}=    Create List
    FOR    ${temp_element}    IN    @{temp_elements}
        ${temp_text}=    Get Text    ${temp_element}
        Append To List    ${temp_list}    ${temp_text}
    END
    [Return]    ${temp_list}



Create Excel
    [Arguments]    ${file_name}    ${header}    ${signals}    ${body}
    Create Workbook    ${file_name}
    Set Worksheet Value    1    1    日期
    Set Worksheet Value    1    2    預報
    Set Worksheet Value    1    3    氣溫
    
    ${table}=    Create Dictionary    日期=${header}    預報=${signals}   氣溫=${body} 
    Append rows to worksheet    ${table}
    Save Workbook
    Close Workbook
