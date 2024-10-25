﻿// Комментарий к тестовому HTTP сервису.
//
// GET /swagger_test/first
//  @summary Получение каких-то данных из 1С
//  @description Эти данные предназначены для чего-то большего чем быть просто обычным тестом
//  @pathParam {string} param1 - Какое-то описание параметра
//  @pathParam {int64} param2 - Ещё какой-то параметр
//  @responseContent {TestObject} 200.application/json
//  @response 200 - Success
//  @response 401 - Unauthorized
//
Функция ТестовыйGET(Запрос)
	
	РезультатПроверкиПараметров = Swag_ОбработкаHTTP.ПроверитьПараметры("SwagTest_Тестовый_HTTPСервис", "ТестовыйGET", Запрос);
	Если Не ПустаяСтрока(РезультатПроверкиПараметров) Тогда
		Возврат Swag_ОбработкаHTTP.ПолучитьОтветОшибки(РезультатПроверкиПараметров, Истина);
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(200);
	СтрокаОтвета = "{
	|	""param1"": """ + Запрос["ПараметрыЗапроса"].Получить("param1") + """,
	|	""param2"": """ + Запрос["ПараметрыЗапроса"].Получить("param2") + """
	|}";
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	Ответ.УстановитьТелоИзСтроки(СтрокаОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ТестовыйGET", Ответ);
	
КонецФункции

// Комментарий к другому тестовому HTTP сервису.
//
// POST /swagger_test/first
//  @summary Отправка каких-то данных в 1С
//  @bodyContent {TestPostObject} application/json
//
Функция ТестовыйPOST(Запрос)
	
	РезультатПроверкиПараметров = Swag_ОбработкаHTTP.ПроверитьПараметры("SwagTest_Тестовый_HTTPСервис", "ТестовыйPOST", Запрос);
	Если Не ПустаяСтрока(РезультатПроверкиПараметров) Тогда
		Возврат Swag_ОбработкаHTTP.ПолучитьОтветОшибки(РезультатПроверкиПараметров, Истина);
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции

Функция ОшибкаНетОписанияGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ОшибкаНетОписанияGET", Ответ);
КонецФункции

Функция ОшибкаНетОтветовGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ОшибкаНетОтветовGET", Ответ);
КонецФункции

Функция ОшибкаНетНужногоКодаОтветаGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ОшибкаНетНужногоКодаОтветаGET", Ответ);
КонецФункции

Функция ОшибкаНеЗаданТипMIMEGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ОшибкаНеЗаданТипMIMEGET", Ответ);
КонецФункции

Функция ОшибкаНекорректныйТипMIMEGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "text/plain");
	Возврат Swag_ОбработкаHTTP.ПроверитьОтвет("SwagTest_Тестовый_HTTPСервис", "ОшибкаНекорректныйТипMIMEGET", Ответ);
КонецФункции
