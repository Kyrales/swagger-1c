﻿////////////////////////////////////////////////////////////////////////////////
// API Биллинг для Демонстрационная конфигурация "Библиотека стандартных подсистем"
// Базовая документация: https://zerobig.github.io/swagger-1c/docs/getting-started/
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Содержит общие настройки
// 
// Возвращаемое значение:
//  Стуктура - содержит свойства:
//		* НеОтображать - булево - Если истина, то API не будет отображаться в Swagger 
//		* Описание - строка - описание для чего предназначено данное API 
//
Функция ПолучитьОбщиеНастройки() Экспорт

	Настройки = Новый Структура;
	Настройки.Вставить("НеОтображать", Ложь);  // Если истина, то API не будет отображаться в Swagger
	Настройки.Вставить("Описание", "Сервис Биллинг"); // Общее описание
	
	Возврат Настройки;

КонецФункции

// Возвращает основной массив описаний HTTP-Сервиса
// 
// Возвращаемое значение:
//  Массив - Список сформированного описания методов HTTP-сервиса. См. https://zerobig.github.io/swagger-1c/docs/getting-started/methods_func_style 
//
Функция ПолучитьОписаниеHTTPСервиса() Экспорт
	
	Методы = Swag_Описание
		.Метод("ВерсияGET") // Имя ручки 1С + Имя свойства (GET, POST и др)
			.ОписаниеМетода("Получение версии")
			.ДетальноеОписаниеМетода(НСтр("ru = 'Получение версии API.
                                           |Есть юнит-тест: Нет'"))  // Да, при наличии юнит-теста на yaxunit.
			.Ответ(200)
				.ОписаниеОтвета("Success").ТипОтвета("application/json")
					.СхемаОтвета("БиллингВерсияGET")
				
		.Сформировать()
		;

	Возврат Методы;

КонецФункции

// Возвращает массив объектов описания HTTP-Сервиса
// 
// Возвращаемое значение:
//  Массив - Список сформированных объектов описания. См. https://zerobig.github.io/swagger-1c/docs/getting-started/objects_func_style
//
Функция ПолучитьОбъектыHTTPСервиса() Экспорт
	
	Объекты = Новый Массив;
	
	Объекты = Swag_Описание
		.Объект("БиллингВерсияGET") // Описание объекта
			.Свойство("version")
				.Описание("Версия интерфейса из функции ОплатаСервиса.ВерсияИнтерфейса()")
				.ТипЗначения("integer")
				.Обязательный()
				.Пример(3)
		.Сформировать()
		;

	Возврат Объекты;		

КонецФункции

#КонецОбласти