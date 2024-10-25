﻿Перем СтруктураОписания;

#Область ПрограммныйИнтерфейс

#Область Метод

//
//
Функция Метод(ИмяМетода) Экспорт
	
	Если ПустаяСтрока(ИмяМетода) Тогда
		ВызватьИсключение "Объект: имя метода не может быть пустым";
	КонецЕсли;
	
	Если СтруктураОписания = Неопределено Тогда
		СтруктураОписания = Новый Структура;
	КонецЕсли;
	
	СтруктураОписания.Вставить("ИмяМетода", ИмяМетода);
	
	ДобавитьПоследнийМетодВМассивМетодов();
	
	// Новый текущий объект
	СтруктураОписания.Вставить("ТекущийМетод",
		Новый Структура("Имя, Описание, Параметры, Ответы, ТелоЗапроса", ИмяМетода));
	
	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция ОписаниеМетода(СтрокаОписания) Экспорт
	
	Если СтруктураОписания = Неопределено Или
		Не СтруктураОписания.Свойство("ИмяМетода") Или
		ПустаяСтрока(СтруктураОписания.ИмяМетода) Тогда
		
		ВызватьИсключение "ОписаниеМетода: нельзя задавать описание для неопределенного метода";
	КонецЕсли;

	СтруктураОписания.ТекущийМетод.Описание = СтрокаОписания;
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти

#Область Параметр

//
//
Функция ПараметрЗапроса(ИмяПараметра) Экспорт
	ДобавитьПараметрВМассивПараметров(ИмяПараметра, "query", "ПараметрЗапроса");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция ПараметрURL(ИмяПараметра) Экспорт
	ДобавитьПараметрВМассивПараметров(ИмяПараметра, "path", "ПараметрURL");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция ПараметрЗаголовка(ИмяПараметра) Экспорт
	ДобавитьПараметрВМассивПараметров(ИмяПараметра, "header", "ПараметрЗаголовка");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция ПараметрФормы(ИмяПараметра) Экспорт
	ДобавитьПараметрВМассивПараметров(ИмяПараметра, "form", "ПараметрФормы");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция ОписаниеПараметра(СтрокаОписания) Экспорт
	УстановитьЗначениеСвойстваПараметра("Описание", СтрокаОписания, "ОписаниеПараметра");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция Обязательный() Экспорт
	УстановитьЗначениеСвойстваПараметра("Обязательный", Истина, "Обязательный");
	Возврат ЭтотОбъект;
КонецФункции

//
//
Функция ТипПараметра(Тип) Экспорт
	УстановитьЗначениеСвойстваПараметра("ТипПараметра", Тип, "ТипПараметра");
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область Ответ

//
//
Функция Ответ(КодОтвета) Экспорт
	
	ПроверитьДанныеМетода("Ответ", "ответ");

	СтруктураОписания.Вставить("КодТекущегоОтвета", КодОтвета);
	
	МассивОтветов = Новый Массив;
	Если СтруктураОписания.ТекущийМетод.Свойство("Ответы") И
		ТипЗнч(СтруктураОписания.ТекущийМетод.Ответы) = Тип("Массив") Тогда
		
		МассивОтветов = СтруктураОписания.ТекущийМетод.Ответы;
	КонецЕсли;
	
	МассивОтветов.Добавить(Новый Структура("Код, Описание, МассивТиповMIME", КодОтвета));
	СтруктураОписания.ТекущийМетод.Вставить("Ответы", МассивОтветов);
	
	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция ОписаниеОтвета(СтрокаОписания) Экспорт
	
	ПроверитьДанныеОтвета("ОписаниеОтвета");
	
	Для каждого Ответ Из СтруктураОписания.ТекущийМетод.Ответы Цикл
		Если Ответ.Код = СтруктураОписания.КодТекущегоОтвета Тогда
			Ответ.Описание = СтрокаОписания;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция ТипОтвета(Заголовок) Экспорт
	
	ПроверитьДанныеОтвета("ТипОтвета");

	Для каждого Ответ Из СтруктураОписания.ТекущийМетод.Ответы Цикл
		Если Ответ.Код = СтруктураОписания.КодТекущегоОтвета Тогда
			МассивТиповMIME = Новый Массив;
			Если Ответ.Свойство("МассивТиповMIME") И ТипЗнч(Ответ.МассивТиповMIME) = Тип("Массив") Тогда
				МассивТиповMIME = Ответ.МассивТиповMIME;
			КонецЕсли;
				
			МассивТиповMIME.Добавить(Новый Структура("Заголовок, Тип, Схема", Заголовок));
			Ответ.МассивТиповMIME = МассивТиповMIME;

			СтруктураОписания.Вставить("ЗаголовокТекущегоОтвета", Заголовок);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция СхемаОтвета(ТипОбъекта) Экспорт
	
	ПроверитьДанныеОтвета("СхемаОтвета");
	Если Не СтруктураОписания.Свойство("ЗаголовокТекущегоОтвета") Или
		ПустаяСтрока(СтруктураОписания.ЗаголовокТекущегоОтвета) Тогда
		
		ВызватьИсключение "СхемаОтвета: нельзя задавать схему ответа для неопределенного типа ответа";
	КонецЕсли;
	
	Нашли = Ложь;
	Для каждого Ответ Из СтруктураОписания.ТекущийМетод.Ответы Цикл
		Если Ответ.Код = СтруктураОписания.КодТекущегоОтвета Тогда
			Для каждого ТипMIME Из Ответ.МассивТиповMIME Цикл
				Если ТипMIME.Заголовок = СтруктураОписания.ЗаголовокТекущегоОтвета Тогда
					ТипMIME.Схема = ТипОбъекта;
					
					Нашли = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если Нашли Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти

#Область Тело

//
//
Функция Тело(СтрокаОписания = Неопределено) Экспорт
	
	ПроверитьДанныеМетода("Тело", "тело запроса");
	
	СтруктураОписания.ТекущийМетод.Вставить("ТелоЗапроса",
		Новый Структура("Описание, МассивТиповMIME", СтрокаОписания));
	
	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция ТипТела(Заголовок) Экспорт
	
	ПроверитьДанныеТела("ТипТела");
	
	МассивТиповMIME = Новый Массив;
	Если СтруктураОписания.ТекущийМетод.ТелоЗапроса.Свойство("МассивТиповMIME") И
		ТипЗнч(СтруктураОписания.ТекущийМетод.ТелоЗапроса.МассивТиповMIME) = Тип("Массив") Тогда
		
		МассивТиповMIME = СтруктураОписания.ТекущийМетод.ТелоЗапроса.МассивТиповMIME;
	КонецЕсли;
		
	МассивТиповMIME.Добавить(Новый Структура("Заголовок, Тип, Схема", Заголовок));
	СтруктураОписания.ТекущийМетод.ТелоЗапроса.МассивТиповMIME = МассивТиповMIME;

	СтруктураОписания.Вставить("ЗаголовокТелаЗапроса", Заголовок);
	
	Возврат ЭтотОбъект;
	
КонецФункции

//
//
Функция СхемаТела(ТипОбъекта) Экспорт
	
	ПроверитьДанныеТела("ТипТела");
	
	Для каждого ТипMIME Из СтруктураОписания.ТекущийМетод.ТелоЗапроса.МассивТиповMIME Цикл
		Если ТипMIME.Заголовок = СтруктураОписания.ЗаголовокТелаЗапроса Тогда
			ТипMIME.Схема = ТипОбъекта;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЭтотОбъект;
	
КонецФункции

#КонецОбласти

//
//
Функция Сформировать() Экспорт
	
	ДобавитьПоследнийМетодВМассивМетодов();
	
	МассивОписанийМетодов = Новый Массив;
	Если СтруктураОписания.Свойство("МассивМетодов") И
		ТипЗнч(СтруктураОписания.МассивМетодов) = Тип("Массив") Тогда
		
		Для каждого Метод Из СтруктураОписания.МассивМетодов Цикл
			МассивОписанийМетодов.Добавить(
				Swag_ФормированиеОписаний.ОписаниеМетода(Метод.Имя, Метод.Описание,
					Метод.Параметры, Метод.Ответы, Метод.ТелоЗапроса));
		КонецЦикла;
	КонецЕсли;
	
	Возврат МассивОписанийМетодов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПоследнийМетодВМассивМетодов()
	
	Если СтруктураОписания.Свойство("ТекущийМетод") И
		ТипЗнч(СтруктураОписания.ТекущийМетод) = Тип("Структура")
		И Не СтруктураОписания.ТекущийМетод.Количество() = 0 Тогда
		
		МассивМетодов = Новый Массив;
		Если СтруктураОписания.Свойство("МассивМетодов") И
			ТипЗнч(СтруктураОписания.МассивМетодов) = Тип("Массив") Тогда
			
			МассивМетодов = СтруктураОписания.МассивМетодов;
		КонецЕсли;
		
		МассивМетодов.Добавить(СтруктураОписания.ТекущийМетод);
		СтруктураОписания.Вставить("МассивМетодов", МассивМетодов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПараметрВМассивПараметров(ИмяПараметра, ТипПараметра, НазваниеПроцедуры)

	Если СтруктураОписания = Неопределено Или
		Не СтруктураОписания.Свойство("ИмяМетода") Или
		ПустаяСтрока(СтруктураОписания.ИмяМетода) Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать параметр для неопределенного метода",
			НазваниеПроцедуры);
	КонецЕсли;
	Если ПустаяСтрока(ИмяПараметра) Тогда
		ВызватьИсключение СтрШаблон("%1: имя параметра не может быть пустым", НазваниеПроцедуры);
	КонецЕсли;

	СтруктураОписания.Вставить("ИмяТекущегоПараметра", ИмяПараметра);
	
	МассивПараметров = Новый Массив;
	Если СтруктураОписания.ТекущийМетод.Свойство("Параметры") И
		ТипЗнч(СтруктураОписания.ТекущийМетод.Параметры) = Тип("Массив") Тогда
		
		МассивПараметров = СтруктураОписания.ТекущийМетод.Параметры;
	КонецЕсли;
	
	МассивПараметров.Добавить(Новый Структура("Имя, Описание, ТипПараметра, Обязательный, Устарел, ТипЗначения",
		ИмяПараметра, , ТипПараметра));
	СтруктураОписания.ТекущийМетод.Вставить("Параметры", МассивПараметров);
	
КонецПроцедуры

Процедура УстановитьЗначениеСвойстваПараметра(ИмяСвойстваПараметра, Значение, НазваниеПроцедуры)

	Если СтруктураОписания = Неопределено Или
		Не СтруктураОписания.Свойство("ИмяМетода") Или
		ПустаяСтрока(СтруктураОписания.ИмяМетода) Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать свойство параметра для неопределенного метода",
			НазваниеПроцедуры);
	КонецЕсли;
	Если Не СтруктураОписания.Свойство("ИмяТекущегоПараметра") Или
		ПустаяСтрока(СтруктураОписания.ИмяТекущегоПараметра) Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать свойство параметра для неопределенного параметра",
			НазваниеПроцедуры);
	КонецЕсли;
	
	Для каждого Параметр Из СтруктураОписания.ТекущийМетод.Параметры Цикл
		Если Параметр.Имя = СтруктураОписания.ИмяТекущегоПараметра Тогда
			Параметр[ИмяСвойстваПараметра] = Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДанныеОтвета(НазваниеПроцедуры)
	
	ПараметрШаблона = "свойство ответа";
	ПроверитьДанныеМетода(НазваниеПроцедуры, ПараметрШаблона);
	Если Не СтруктураОписания.Свойство("КодТекущегоОтвета") Или
		Не ЗначениеЗаполнено(СтруктураОписания.КодТекущегоОтвета) Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать %2 для неопределенного ответа",
			НазваниеПроцедуры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеТела(НазваниеПроцедуры)
	
	ПараметрШаблона = "тип тела запроса";
	ПроверитьДанныеМетода(НазваниеПроцедуры, ПараметрШаблона);
	Если Не СтруктураОписания.ТекущийМетод.Свойство("ТелоЗапроса") Или
		Не ТипЗнч(СтруктураОписания.ТекущийМетод.ТелоЗапроса) = Тип("Структура") Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать %2 для неопределенного тела",
			НазваниеПроцедуры, ПараметрШаблона);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДанныеМетода(НазваниеПроцедуры, ПараметрШаблона)

	Если СтруктураОписания = Неопределено Или
		Не СтруктураОписания.Свойство("ИмяМетода") Или
		ПустаяСтрока(СтруктураОписания.ИмяМетода) Тогда
		
		ВызватьИсключение СтрШаблон("%1: нельзя задавать %2 для неопределенного метода",
			НазваниеПроцедуры, ПараметрШаблона);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
