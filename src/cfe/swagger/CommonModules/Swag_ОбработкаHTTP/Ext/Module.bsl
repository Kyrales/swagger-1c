﻿#Область ПрограммныйИнтерфейс

// Проверяет входящие параметры HTTP сервиса на соответствие описанию.
//
// Параметры:
//  ИмяСервиса - Строка - Наименование HTTP сервиса как оно задано в конфигураторе.
//  ИмяМетода - Строка - Имя метода HTTP сервиса.
//  Запрос - HTTPСервисЗапрос - Входящий зпрос HTTP сервиса, который будет проверен на соответствие описанию.
//  ЗаписыватьОшибкуВЖурналРегистрации - Булево - Способ обработки несоответствий описания и ответа.
//                                                Истина - запись в журнал регистрации,
//                                                Ложь - в ответе будет возвращен JSON с ошибкой.
//
// Возвращаемое значение:
//  Строка - Текст несоответствия HTTP запроса и описания HTTP сервиса
//
Функция ПроверитьПараметры(ИмяСервиса, ИмяМетода, Запрос, ЗаписыватьОшибкуВЖурналРегистрации = Истина) Экспорт
	
	Попытка
		МодульОписанияHTTPСервиса = ОбщегоНазначения.ОбщийМодуль(ИмяСервиса + "Описание");
		Описание = МодульОписанияHTTPСервиса.ПолучитьОписаниеHTTPСервиса();
		Объекты = МодульОписанияHTTPСервиса.ПолучитьОбъектыHTTPСервиса();
	Исключение
		Возврат "";
	КонецПопытки;

	ИмяСобытияЖурналаРегистрации = "Swagger: проверка корректности HTTP запроса";
	ТекстМетодСервис = "метода """ + ИмяМетода + """ HTTP сервиса """ + ИмяСервиса + """";

	СообщениеОбОшибке = "";
	
	ОписаниеМетода = ПолучитьЗначениеОписанияМетода(Описание, ИмяМетода, "Описание");
	Если ЗначениеЗаполнено(ОписаниеМетода) Тогда
		
		ПараметрыМетода = ПолучитьМассивЭлементовОписания(Описание, ИмяМетода, "Параметры");
		Если Запрос.ПараметрыЗапроса.Количество() > 0 И ПараметрыМетода.Количество() = 0 Тогда
			СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
				" были переданы параметры хотя в документации какие-либо параметры описаны не были.'");
		КонецЕсли;
		
		Для каждого ПараметрЗапроса Из Запрос.ПараметрыЗапроса Цикл
			ПараметрМетода = ПолучитьПараметрМетода(ПараметрыМетода, ПараметрЗапроса.Ключ);
			Если ПараметрМетода = Неопределено Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
					" был передан параметр с именем """ + ПараметрЗапроса.Ключ + """ для которого отсутствует описание.'");
			КонецЕсли;
			Если ПараметрМетода.Устарел Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
					" был передан устаревший параметр с именем """ + ПараметрМетода.Имя + """.'");
			КонецЕсли;
		КонецЦикла;
		Для каждого ПараметрМетода Из ПараметрыМетода Цикл
			Если ПараметрМетода.Обязательный И Запрос.ПараметрыЗапроса.Получить(ПараметрМетода.Имя) = Неопределено Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
					" не был передан обязательный параметр с именем """ + ПараметрМетода.Имя + """.'");
			КонецЕсли;
		КонецЦикла;
		
		ТелоМетода = ПолучитьЗначениеОписанияМетода(Описание, ИмяМетода, "ТелоЗапроса");
		ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
		Если ТелоМетода = Неопределено Тогда
			Если Не ПустаяСтрока(ТелоЗапроса) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
					" было передано тело запроса для которого отсутствует описание.'");
			КонецЕсли;
		Иначе
			Если ПустаяСтрока(ТелоЗапроса) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис + " не было передано тело запроса.'");
			Иначе
				// TODO: Пока речь идёт только о JSON. Нужно проработать другие возможные варианты.
				СхемаТелаПоMIME = ПолучитьОписаниеТела(ТелоМетода, "application/json");
				Если Не СхемаТелаПоMIME = Неопределено Тогда
					
					ОбъектТела = ПолучитьОбъектПоИмениСхемы(Объекты, СхемаТелаПоMIME);
					Если Не ОбъектТела = Неопределено Тогда
				
						ЧтениеJSON = Новый ЧтениеJSON;
						ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
						
						Попытка
							ТелоКакСоответствие = ПрочитатьJSON(ЧтениеJSON, Истина);
						Исключение
							СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
								" тело запроса не является корректной структурой JSON.'");
						КонецПопытки;
						
						Если ПустаяСтрока(СообщениеОбОшибке) Тогда
							СообщениеОбОшибке = ПроверитьТелоЗапроса(ОбъектТела, ТелоКакСоответствие);
						КонецЕсли;
						
						ЧтениеJSON.Закрыть();
					
					Иначе
						СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
							" в описании не определен объект для схемы """ + СхемаТелаПоMIME + """.'");
					КонецЕсли;
					
				Иначе
					СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
						" в описании не определена схема запроса ""application/json"".'");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		СообщениеОбОшибке = НСтр("ru = 'Отсутствует swagger описание " + ТекстМетодСервис + ".'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда
		Если ЗаписыватьОшибкуВЖурналРегистрации Тогда
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
		КонецЕсли;
	КонецЕсли;

	Возврат СообщениеОбОшибке;
	
КонецФункции

// Проверяет ответ HTTP сервиса на соответствие описанию.
//
// Параметры:
//  ИмяСервиса - Наименование HTTP сервиса как оно задано в конфигураторе.
//  ИмяМетода - Имя метода HTTP сервиса.
//  Ответ - HTTPСервисОтвет - Подготовленный ответ HTTP сервиса, который будет проверен на соответствие описанию.
//  ЗаписыватьОшибкуВЖурналРегистрации - Булево - Способ обработки несоответствий описания и ответа.
//                                                Истина - запись в журнал регистрации,
//                                                Ложь - в ответе будет возвращен JSON с ошибкой.
//
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ HTTP сервиса для отдачи.
//
Функция ПроверитьОтвет(ИмяСервиса, ИмяМетода, Ответ, ЗаписыватьОшибкуВЖурналРегистрации = Истина) Экспорт
	
	Попытка
		МодульОписанияHTTPСервиса = ОбщегоНазначения.ОбщийМодуль(ИмяСервиса + "Описание");
		Описание = МодульОписанияHTTPСервиса.ПолучитьОписаниеHTTPСервиса();
		Объекты = МодульОписанияHTTPСервиса.ПолучитьОбъектыHTTPСервиса();
	Исключение
		Возврат Ответ;
	КонецПопытки;
	
	ИмяСобытияЖурналаРегистрации = "Swagger: проверка корректности HTTP ответа";
	ТекстМетодСервис = "метода """ + ИмяМетода + """ HTTP сервиса """ + ИмяСервиса + """";
	
	СообщениеОбОшибке = "";
	
	ОписаниеМетода = ПолучитьЗначениеОписанияМетода(Описание, ИмяМетода, "Описание");
	Если ЗначениеЗаполнено(ОписаниеМетода) Тогда
		
		ОтветыМетода = ПолучитьМассивЭлементовОписания(Описание, ИмяМетода, "Ответы");
		Если ОтветыМетода.Количество() > 0 Тогда
			
			ОтветМетода = ПолучитьОтветПоКоду(ОтветыМетода, Ответ.КодСостояния);
			Если ОтветМетода = Неопределено Тогда
				СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис + " не определён код ответа " + Ответ.КодСостояния + ".'");
			Иначе
				Если ТипЗнч(ОтветМетода.МассивТиповMIME) = Тип("Массив") И ОтветМетода.МассивТиповMIME.Количество() > 0 Тогда
					
					ТипMIMEОтвета = Ответ.Заголовки.Получить("Content-Type");
					Если ТипMIMEОтвета = Неопределено Тогда
						СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис + " в ответе не задан тип MIME.'");
					Иначе
						НайденТипMIME = Ложь;
						Для каждого ТипMIME Из ОтветМетода.МассивТиповMIME Цикл
							Если ТипMIME.Заголовок = ТипMIMEОтвета Тогда
								НайденТипMIME = Истина;
								Прервать;
							КонецЕсли;
						КонецЦикла;
						Если Не НайденТипMIME Тогда
							СообщениеОбОшибке = НСтр("ru = 'Для " + ТекстМетодСервис +
								" в ответе возвращается не описанный в документации тип MIME.'");
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			СообщениеОбОшибке = НСтр("ru = 'Не заданы варианты ответов " + ТекстМетодСервис + ".'");
		КонецЕсли;
		
	Иначе
		СообщениеОбОшибке = НСтр("ru = 'Отсутствует swagger описание " + ТекстМетодСервис + ".'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда
		Если ЗаписыватьОшибкуВЖурналРегистрации Тогда
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,,, СообщениеОбОшибке);
		Иначе
			Возврат ПолучитьОтветОшибки(СообщениеОбОшибке, Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

//
//
Функция ПолучитьМассивЭлементовОписания(Описание, Метод, ЭлементОписания) Экспорт
	
	Параметры = Новый Массив;
	
	Если ТипЗнч(Описание) = Тип("Массив") Тогда
		
		Для каждого ДанныеОписания Из Описание Цикл
			Если ТипЗнч(ДанныеОписания) = Тип("Структура") И ДанныеОписания.Свойство("Имя") Тогда
				Если ДанныеОписания.Имя = Метод И ДанныеОписания.Свойство(ЭлементОписания) Тогда
					ПараметрыМетода = Неопределено;
					ДанныеОписания.Свойство(ЭлементОписания, ПараметрыМетода);
					Если ТипЗнч(ПараметрыМетода) = Тип("Массив") Тогда
						Параметры = ПараметрыМетода;
					КонецЕсли;
					
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

//
//
Функция ПолучитьЗначениеОписанияМетода(Описание, Метод, ЭлементОписания) Экспорт
	
	ОписаниеМетода = Неопределено;
	
	Если ТипЗнч(Описание) = Тип("Массив") Тогда
		
		Для каждого ДанныеОписания Из Описание Цикл
			Если ТипЗнч(ДанныеОписания) = Тип("Структура") И ДанныеОписания.Свойство("Имя") Тогда
				Если ДанныеОписания.Имя = Метод И ДанныеОписания.Свойство(ЭлементОписания) Тогда
					ЗначениеМетода = Неопределено;
					ДанныеОписания.Свойство(ЭлементОписания, ЗначениеМетода);
					ОписаниеМетода = ЗначениеМетода;
					
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ОписаниеМетода;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОтветПоКоду(ОтветыМетода, Код)
	
	НайденныйОтветМетода = Неопределено;
	
	Если ТипЗнч(ОтветыМетода) = Тип("Массив") Тогда
		Для каждого ОтветМетода Из ОтветыМетода Цикл
			Если ТипЗнч(ОтветМетода) = Тип("Структура") И ОтветМетода.Свойство("Код") Тогда
				Если ОтветМетода.Код = Код Тогда
					НайденныйОтветМетода = ОтветМетода;
					
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат НайденныйОтветМетода;
	
КонецФункции

// Возвращает подготовленный HTTP ответ с ошибкой.
//
// Параметры:
//  ТекстОшибки - Строка - Текст ошибки.
//  ЭтоЗапрос - Булево - Признак обрабатываемого события.
//                       Истина - ошибка для входящего запроса, Ложь - для исходящего ответа.
//
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ HTTP сервиса с JSON ошибки.
//
Функция ПолучитьОтветОшибки(ТекстОшибки, ЭтоЗапрос) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("subject");
	ЗаписьJSON.ЗаписатьЗначение("Сообщение выдано из-за несоответствия описания HTTP сервиса и параметров " +
		?(ЭтоЗапрос, "запроса", "ответа") +
		". Необходимо привести описание в соответствии с кодом (рекомендуется) или убрать функцию проверки.");
	
	ЗаписьJSON.ЗаписатьИмяСвойства("message");
	ЗаписьJSON.ЗаписатьЗначение(Строка(ТекстОшибки));
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
	Ответ = Новый HTTPСервисОтвет(500);
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	Ответ.УстановитьТелоИзСтроки(ЗаписьJSON.Закрыть());
	
	Возврат Ответ;
	
КонецФункции

Функция ПолучитьПараметрМетода(ПараметрыМетода, КлючПараметраЗапроса)
	
	Для каждого ПараметрМетода Из ПараметрыМетода Цикл
		Если ПараметрМетода.Имя = КлючПараметраЗапроса Тогда
			Возврат ПараметрМетода;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьОписаниеТела(ТелоМетода, НаименованиеТипаMIME)
	
	Для каждого ТипMIME Из ТелоМетода.МассивТиповMIME Цикл
		Если ТипMIME.Заголовок = НаименованиеТипаMIME Тогда
			// TODO: Возможность работать не только со схемой, но и с типом
			Возврат ТипMIME.Схема;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьОбъектПоИмениСхемы(ОбъектыСервиса, ПутьКСхеме)
	
	ЭлементыПутиСхемы = СтрРазделить(ПутьКСхеме, "/");
	ИмяОбъекта = ЭлементыПутиСхемы[ЭлементыПутиСхемы.Количество() - 1];
	
	Для каждого ОбъектСервиса Из ОбъектыСервиса Цикл
		Если ОбъектСервиса.Имя = ИмяОбъекта Тогда
			Возврат ОбъектСервиса;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПроверитьТелоЗапроса(ОбъектСервиса, ТелоКакСоответствие)
	
	// TODO:
	Возврат "";
	
КонецФункции

#КонецОбласти
