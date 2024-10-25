﻿
#Область ОбъявлениеТестов

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты
		.ДобавитьТестовыйНабор("Swagger: Базовые")
			.ДобавитьТест("ПолучитьSwaggerФайл")
		.ДобавитьТестовыйНабор("Swagger: функциональное описание объекты")
			.ДобавитьТест("СоздатьОбъектБезСвойств")
			.ДобавитьТест("СоздатьСвойствоОбъекта")
			.ДобавитьТест("ЗадатьТипСвойстваЧисло")
			.ДобавитьТест("ЗадатьТипСвойстваСтрока")
			.ДобавитьТест("ЗадатьТипСвойстваМассивБезЗаданияТипаЭлементов")
			.ДобавитьТест("ЗадатьТипСвойстваМассивСТипомЭлементов")
			.ДобавитьТест("ЗадатьТипСвойстваРекурсивныйМассив")
			.ДобавитьТест("ЗадатьПример")
		.ДобавитьТестовыйНабор("Swagger: функциональное описание методы")
			.ДобавитьТест("СоздатьМетод")
		.ДобавитьТестовыйНабор("Swagger: тестовое описание")
			.ДобавитьТест("СоздатьМассивОбъектов")
			.ДобавитьТест("СоздатьМассивМетодов")
	;

КонецПроцедуры

#КонецОбласти

#Область События



#КонецОбласти

#Область Тесты

#Область Базовые

Процедура ПолучитьSwaggerФайл() Экспорт
	
	Запрос = ЮТест.Данные().HTTPСервисЗапрос();
	Запрос.ПараметрыURL.Вставить("File", "swagger.json");
	
	Результат = Swag_Запросы.ПолучитьSwaggerFileGET(Запрос);
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Результат.ПолучитьТелоКакСтроку());
	// Читаю в соответствие т.к. у swagger.json названия полей со слэшами
	СоответствиеОтвета = ПрочитатьJSON(ЧтениеJSON, Истина);
	
	ЮТест.ОжидаетЧто(СоответствиеОтвета)
		.ИмеетТип("Соответствие")
	;
	
КонецПроцедуры

#КонецОбласти

#Область Объекты

Процедура СоздатьОбъектБезСвойств() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
		)
	;
		
КонецПроцедуры

Процедура СоздатьСвойствоОбъекта() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
		)
	;
	
КонецПроцедуры

Процедура ЗадатьТипСвойстваЧисло() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.ТипЗначения("integer")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Тип").Равно("integer")
		)
	;

КонецПроцедуры

Процедура ЗадатьТипСвойстваСтрока() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.ТипЗначения("string")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Тип").Равно("string")
		)
	;

КонецПроцедуры

Процедура ЗадатьТипСвойстваМассивБезЗаданияТипаЭлементов() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.ТипЗначения("array")
		.Сформировать()
	;

	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Тип").Равно("array")
		)
	;
	
КонецПроцедуры

Процедура ЗадатьТипСвойстваМассивСТипомЭлементов() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.ТипЗначения("array")
			.Схема("Элемент массива")
		.Сформировать()
	;

	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Тип").Равно("array")
				.Свойство("МассивСвойств[0].Схема").Равно("#/components/schemas/Элемент массива")
		)
	;
	
КонецПроцедуры

Процедура ЗадатьТипСвойстваРекурсивныйМассив() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.ТипЗначения("array")
			.Схема("Тестовый объект")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Тип").Равно("array")
				.Свойство("МассивСвойств[0].Схема").Равно("#/components/schemas/Тестовый объект")
		)
	;
	
КонецПроцедуры

Процедура ЗадатьПример() Экспорт
	
	МассивОбъектов = Swag_Описание.Объект("Тестовый объект")
		.Свойство("Тестовое свойство")
			.Пример("Тестовый пример")
		.Сформировать()
	;
	
	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(1)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("Тестовый объект")
			.Свойство("Тип").Равно("object")
			.Свойство("МассивСвойств")
				.ИмеетТип("Массив")
				.ИмеетДлину(1)
			.Свойство("МассивСвойств[0]")
				.ИмеетТип("Структура")
				.Свойство("МассивСвойств[0].Имя").Равно("Тестовое свойство")
				.Свойство("МассивСвойств[0].Пример").Равно("Тестовый пример")
		)
	;
		
КонецПроцедуры

#КонецОбласти

#Область Методы

Процедура СоздатьМетод() Экспорт
	
	МассивМетодов = Swag_Описание.Метод("Тестовый метод")
		.Сформировать()
	;
	
КонецПроцедуры

Процедура СоздатьМетодСОписанием() Экспорт

	МассивМетодов = Swag_Описание.Метод("Тестовый метод")
		.ОписаниеМетода("Тестовое описание тестового метода")
		.Сформировать()
	;

КонецПроцедуры

Процедура СоздатьУстаревшийМетод() Экспорт

	МассивМетодов = Swag_Описание.Метод("Тестовый метод")
		.Устарел()
		.Сформировать()
	;

КонецПроцедуры

#КонецОбласти

#Область ТестовоеОписание

Процедура СоздатьМассивОбъектов() Экспорт
	
	МассивОбъектов = SwagTest_Тестовый_HTTPСервис3Описание
		.ПолучитьОбъектыHTTPСервиса();

	ЮТест.ОжидаетЧто(МассивОбъектов)
		.ИмеетТип("Массив")
		.ИмеетДлину(3)
	;
		
КонецПроцедуры

Процедура СоздатьМассивМетодов() Экспорт
	
	МассивМетодов = SwagTest_Тестовый_HTTPСервис3Описание
		.ПолучитьОписаниеHTTPСервиса();
	
	ЮТест.ОжидаетЧто(МассивМетодов)
		.ИмеетТип("Массив")
		.ИмеетДлину(6)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ТестовыйGET")
			.Свойство("Параметры")
				.ИмеетТип("Массив")
				.ИмеетДлину(2)
			.Свойство("Ответы")
				.ИмеетТип("Массив")
				.ИмеетДлину(2)
		)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ТестовыйPOST")
			.Свойство("ТелоЗапроса")
				.ИмеетТип("Структура")
		)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ОшибкаНетОтветовGET")
		)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ОшибкаНетНужногоКодаОтветаGET")
		)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ОшибкаНеЗаданТипMIMEGET")
		)
		.Содержит(ЮТест.Предикат()
			.ИмеетТип("Структура")
			.Свойство("Имя").Равно("ОшибкаНекорректныйТипMIMEGET")
		)
	;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
