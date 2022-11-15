﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СисИнфо = Новый СистемнаяИнформация;
	ИнформацияОСистеме = ИнформацияОСистеме();
	
	Элементы.ДекорацияВерсияПлатформы.Заголовок		= "Платформа: " + ИнформацияОСистеме.ВерсияПлатформы;
	Элементы.ДекорацияКонфигурация.Заголовок		= "Конфигурация: " + ИнформацияОСистеме.Конфигурация + " (" + ИнформацияОСистеме.ВерсияКонфигурации + ")";
	Элементы.ДекорацияВерсияБСП.Заголовок			= "Версия БСП: " + ИнформацияОСистеме.ВерсияБСП;
	Элементы.ДекорацияТипПлатформыСервер.Заголовок	= "Тип платформы (сервер): " + ИнформацияОСистеме.ТипПлатформы;
	Элементы.ДекорацияТипПлатформыКлиент.Заголовок	= "Тип платформы (клиент): " + Строка(СисИнфо.ТипПлатформы);
	
КонецПроцедуры


&НаСервере
Функция НайтиПоКодуМаркировки(ШтрихКод)
	
	Если (Сред(ШтрихКод,1,2) = "01" и Сред(ШтрихКод,17,2) = "21") Тогда
		НачальныйШтрих = "("+Сред(ШтрихКод,1,2)+")"+Сред(ШтрихКод,3,14)+"("+Сред(ШтрихКод,17,2)+")";
		ПолученныйШтрихкод = НачальныйШтрих + Прав(ШтрихКод,СтрДлина(ШтрихКод)-18);
	Иначе
		ПолученныйШтрихкод = ШтрихКод;
	КонецЕсли;
	
	Если Сред(ПолученныйШтрихкод,36,3) = "240" Тогда
		ПолученныйШтрихкод = Сред(ПолученныйШтрихкод, 1, 35) + "(240)" + Сред(ПолученныйШтрихкод, 39, СтрДлина(ПолученныйШтрихкод));
	КонецЕсли;
	
	Запрос = Новый  Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ШтрихкодыУпаковокТоваров.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
	               |ГДЕ
	               |	ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода = &ЗначениеШтрихкода";
	Запрос.УстановитьПараметр("ЗначениеШтрихкода", ПолученныйШтрихкод);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		ВызватьИсключение(СтрШаблон("По штрихкоду %1 не найден КМ в справочнике", ПолученныйШтрихкод));
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресХранилища)

    Возврат ВнешниеОбработки.Подключить(АдресХранилища,,Ложь);

КонецФункции      


#Область Мониторинг

&НаСервере
Функция ИнформацияОСистеме()
	
	СисИнфо = Новый СистемнаяИнформация;
	
	ИнформацияОСистеме = Новый Структура;
	ИнформацияОСистеме.Вставить("ВерсияПлатформы", СисИнфо.ВерсияПриложения);
	ИнформацияОСистеме.Вставить("Конфигурация", Метаданные.Синоним);
	ИнформацияОСистеме.Вставить("ВерсияКонфигурации", Метаданные.Версия);
	ИнформацияОСистеме.Вставить("ВерсияБСП", СтандартныеПодсистемыСервер.ВерсияБиблиотеки());
	ИнформацияОСистеме.Вставить("ТипПлатформы", Строка(СисИнфо.ТипПлатформы));
	
	Возврат ИнформацияОСистеме;
	
КонецФункции // ИнформацияОСистеме()

&НаКлиенте
Процедура ОткрытьКонсольЗапросов(Команда)
	
	//Помещаем обработку во временном хранилище
    АдресХранилища = "";
    Результат = ПоместитьФайл(АдресХранилища, "V:\Общая папка\Ведерников\Обработки\ИнструментыРазработчикаКонсольЗапросов.epf", , Ложь);           
    ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища);
    
    // Откроем форму подключенной внешней обработки
    ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");
	
КонецПроцедуры

#КонецОбласти


#Область НастройкаПрав

&НаКлиенте
Процедура СправочникИдентификаторыОбъектовМетаданных(Команда)
	ОткрытьФорму("Справочник.ИдентификаторыОбъектовМетаданных.ФормаСписка");
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбновлениеВспомогательныхДанных(Команда)
	
	//Помещаем обработку во временном хранилище
    АдресХранилища = "";
    Результат = ПоместитьФайл(АдресХранилища, "V:\Общая папка\1С\tmplts\1c\SSL\3_1_3_573\ExtFiles\Инструменты разработчика\ОбновлениеВспомогательныхДанных.epf", , Ложь);           
    ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища);
    
    // Откроем форму подключенной внешней обработки
    ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");

КонецПроцедуры

#КонецОбласти 


#Область ОшибкиВАгрегациях

&НаСервере
Процедура ОшибкиВАгрегациях_ПометитьНаУдалениеНаСервере(УдалятьСтрокиВРегистрах)
	
	Сч = 0;
	Для каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
	
		Если ТекСтрока.Выбрано Тогда
			
			ОбСправочник = ТекСтрока.Ссылка.ПолучитьОбъект();
			ОбСправочник.ПометкаУдаления = Истина;
			ОбСправочник.Записать();
			
			ОбСправочникАСУСИЗ = Справочники.АСИЗ_ШтрихкодыУпаковокТоваров.НайтиПоРеквизиту("ШтрихкодУпаковки", ТекСтрока.Ссылка).ПолучитьОбъект();
			ОбСправочникАСУСИЗ.ПометкаУдаления = Истина;
			ОбСправочникАСУСИЗ.Записать();
			
			Если УдалятьСтрокиВРегистрах Тогда
				НаборЗаписей = РегистрыСведений.ТА_СоставАгрегации.СоздатьНаборЗаписей();
			    НаборЗаписей.Отбор.Агрегация.Установить(ТекСтрока.ШтрихкодДляПоиска);
			    НаборЗаписей.Записать(); 
				
				НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
			    НаборЗаписей.Отбор.Штрихкод.Установить(ТекСтрока.ШтрихкодДляПоиска);
			    НаборЗаписей.Записать();
			КонецЕсли;
	
			Сч = Сч + 1;
			
		КонецЕсли;

	КонецЦикла;
	
	ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Помечено на удаление %1 объектов", Сч));
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_ПометитьНаУдаление(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОшибкиВАгрегациях_ПослеЗакрытияВопросаПометкиУдаления", ЭтотОбъект, Параметры);
	ПоказатьВопрос(Оповещение, "Удалять соответствующие записи регистров сведений ""ШтрихкодыНоменклатуры"" и ""ТА_СоставАгрегации""? (Операция необратима!)", РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_ПослеЗакрытияВопросаПометкиУдаления(Результат, Параметры) Экспорт
	
	УдалятьСтрокиВРегистрах = ?(Результат = КодВозвратаДиалога.Да, Истина, Ложь);
	ОшибкиВАгрегациях_ПометитьНаУдалениеНаСервере(УдалятьСтрокиВРегистрах);
	
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОшибкиВАгрегациях_ЗаполнитьНаСервере()
	
	ОбъектТЗ_ОшибкиВАгрегациях = РеквизитФормыВЗначение("ТЗ_ОшибкиВАгрегациях");
	ОбъектТЗ_ОшибкиВАгрегациях.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Ссылка КАК Ссылка,
					|	КОЛИЧЕСТВО(ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Штрихкод) КАК Количество,
					|	ПОДСТРОКА(ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Ссылка.ЗначениеШтрихкода, 5, 19) КАК ШтрихкодДляПоиска
					|ПОМЕСТИТЬ ВТ_Упаковки
					|ИЗ
					|	Справочник.ШтрихкодыУпаковокТоваров.ВложенныеШтрихкоды КАК ШтрихкодыУпаковокТоваровВложенныеШтрихкоды
					|
					|СГРУППИРОВАТЬ ПО
					|	ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Ссылка,
					|	ПОДСТРОКА(ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Ссылка.ЗначениеШтрихкода, 5, 19)
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_Упаковки.Ссылка КАК Ссылка,
					|	ВТ_Упаковки.ШтрихкодДляПоиска КАК ШтрихкодДляПоиска,
					|	ВТ_Упаковки.Количество КАК Количество,
					|	ШтрихкодыНоменклатуры.ТА_Количество КАК ТА_Количество,
					|	КОЛИЧЕСТВО(ТА_СоставАгрегации.КодМаркировки) КАК КоличествоТА_Агрегации,
					|	КОЛИЧЕСТВО(АСИЗ_ШтрихкодыУпаковокТоваров.ШтрихкодУпаковки) КАК КоличествоАСУСИЗ,
					|	ШтрихкодыНоменклатуры.Упаковка КАК Упаковка,
					|	ШтрихкодыНоменклатуры.ТА_Агрегация КАК ТА_Агрегация,
					|	МАКСИМУМ(ПриобретениеТоваровУслугШтрихкодыУпаковок.Ссылка) КАК ДокументПоступления,
					|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПриобретениеТоваровУслугШтрихкодыУпаковок.Ссылка) КАК КоличествоДокументовПоступления
					|ПОМЕСТИТЬ ВТ_Расхождения
					|ИЗ
					|	ВТ_Упаковки КАК ВТ_Упаковки
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
					|		ПО (ВТ_Упаковки.ШтрихкодДляПоиска = ШтрихкодыНоменклатуры.Штрихкод)
					|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТА_СоставАгрегации КАК ТА_СоставАгрегации
					|		ПО (ВТ_Упаковки.ШтрихкодДляПоиска = ТА_СоставАгрегации.Агрегация)
					|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.АСИЗ_ШтрихкодыУпаковокТоваров КАК АСИЗ_ШтрихкодыУпаковокТоваров
					|		ПО (ВТ_Упаковки.Ссылка = АСИЗ_ШтрихкодыУпаковокТоваров.ШтрихкодУпаковки)
					|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.ШтрихкодыУпаковок КАК ПриобретениеТоваровУслугШтрихкодыУпаковок
					|		ПО (ВТ_Упаковки.ШтрихкодДляПоиска = ПриобретениеТоваровУслугШтрихкодыУпаковок.ЗначениеШтрихкода)
					|ГДЕ
					|	ШтрихкодыНоменклатуры.Штрихкод В
					|			(ВЫБРАТЬ
					|				ВТ_Упаковки.ШтрихкодДляПоиска
					|			ИЗ
					|				ВТ_Упаковки КАК ВТ_Упаковки)
					|	И ПриобретениеТоваровУслугШтрихкодыУпаковок.ЗначениеШтрихкода В
					|			(ВЫБРАТЬ
					|				ВТ_Упаковки.ШтрихкодДляПоиска
					|			ИЗ
					|				ВТ_Упаковки КАК ВТ_Упаковки)
					|
					|СГРУППИРОВАТЬ ПО
					|	ВТ_Упаковки.Ссылка,
					|	ВТ_Упаковки.ШтрихкодДляПоиска,
					|	ВТ_Упаковки.Количество,
					|	ШтрихкодыНоменклатуры.ТА_Количество,
					|	ШтрихкодыНоменклатуры.Упаковка,
					|	ШтрихкодыНоменклатуры.ТА_Агрегация
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ВТ_Расхождения.Ссылка КАК Ссылка,
					|	ВТ_Расхождения.ШтрихкодДляПоиска КАК ШтрихкодДляПоиска,
					|	ВТ_Расхождения.Количество КАК КоличествоУпаковки,
					|	ВТ_Расхождения.ТА_Количество КАК РегистрШК_Количество,
					|	ЛОЖЬ КАК Выбрано,
					|	ВТ_Расхождения.КоличествоТА_Агрегации КАК КоличествоТА_Агрегации,
					|	ВТ_Расхождения.КоличествоАСУСИЗ КАК КоличествоАСУСИЗ,
					|	ВТ_Расхождения.Упаковка КАК РегистрШК_Упаковка,
					|	ВТ_Расхождения.ТА_Агрегация КАК РегистрШК_ТА_Агрегация,
					|	ВТ_Расхождения.ДокументПоступления КАК ДокументПоступления,
					|	"""" КАК ОписаниеОшибки,
					|	ВТ_Расхождения.КоличествоДокументовПоступления КАК КоличествоДокументовПоступления
					|ИЗ
					|	ВТ_Расхождения КАК ВТ_Расхождения
					|ГДЕ
					|	(ВТ_Расхождения.Количество <> ВТ_Расхождения.ТА_Количество
					|			ИЛИ (ВТ_Расхождения.ТА_Количество <> ВТ_Расхождения.КоличествоТА_Агрегации И ВТ_Расхождения.КоличествоДокументовПоступления <= 1)
					|			ИЛИ ВТ_Расхождения.ТА_Агрегация = ЛОЖЬ
					|			ИЛИ ВТ_Расхождения.ТА_Количество = 0
					|			ИЛИ ВТ_Расхождения.Упаковка = НЕОПРЕДЕЛЕНО)
					|
					|УПОРЯДОЧИТЬ ПО
					|	ШтрихкодДляПоиска";
	ОбъектТЗ_ОшибкиВАгрегациях = Запрос.Выполнить().Выгрузить();
	КоличествоОшибок = ОбъектТЗ_ОшибкиВАгрегациях.Количество();
	
	ЗначениеВРеквизитФормы(ОбъектТЗ_ОшибкиВАгрегациях, "ТЗ_ОшибкиВАгрегациях");
	
	Элементы.ГруппаНеверныеАгрегации.Заголовок = ?(КоличествоОшибок = 0, "Ошибки в агрегациях", СтрШаблон("Ошибки в агрегациях (%1)", КоличествоОшибок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_Заполнить(Команда)
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОшибкиВАгрегациях_СнятьПометкуНаУдалениеНаСервере()
	
	Сч = 0;
	Для каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
	
		Если ТекСтрока.Выбрано Тогда
			ОбСправочник = ТекСтрока.Ссылка.ПолучитьОбъект();
			ОбСправочник.ПометкаУдаления = Ложь;
			ОбСправочник.Записать();
			Сч = Сч + 1;
		КонецЕсли;

	КонецЦикла;
	
	ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Снята пометка на удаление %1 объектов", Сч));
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_СнятьПометкуНаУдаление(Команда)
	ОшибкиВАгрегациях_СнятьПометкуНаУдалениеНаСервере();
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОшибкиВАгрегациях_ЗаполнитьКМСправочникаНаОснованииРегистраНаСервере()
	
	Для каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
		Если НЕ ТекСтрока.Выбрано Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ТА_СоставАгрегации.Идентификатор КАК Идентификатор,
		               |	ТА_СоставАгрегации.Агрегация КАК Агрегация,
		               |	ТА_СоставАгрегации.КодМаркировки КАК КодМаркировки
		               |ИЗ
		               |	РегистрСведений.ТА_СоставАгрегации КАК ТА_СоставАгрегации
		               |ГДЕ
		               |	ТА_СоставАгрегации.Агрегация = &Агрегация
		               |ИТОГИ ПО
		               |	Агрегация";
		Запрос.УстановитьПараметр("Агрегация", ТекСтрока.ШтрихкодДляПоиска);
		
		ВыборкаГруппировка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаГруппировка.Следующий() Цикл
			
			ОбШтрихкодыУпаковок = ТекСтрока.Ссылка.ПолучитьОбъект();
			ТЧВложенныеШтрихкоды = ОбШтрихкодыУпаковок.ВложенныеШтрихкоды;
			ТЧВложенныеШтрихкоды.Очистить();
			
			Выборка = ВыборкаГруппировка.Выбрать();
			Пока Выборка.Следующий() Цикл
				НоваяСтрока = ТЧВложенныеШтрихкоды.Добавить();
				НоваяСтрока.Штрихкод = НайтиПоКодуМаркировки(Выборка.КодМаркировки);
			КонецЦикла;
			
			ОбШтрихкодыУпаковок.Записать();
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_ЗаполнитьКМСправочникаНаОснованииРегистра(Команда)
	ОшибкиВАгрегациях_ЗаполнитьКМСправочникаНаОснованииРегистраНаСервере();
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
КонецПроцедуры  

&НаСервере
Процедура ОшибкиВАгрегациях_СоздатьИндивидуальнуюУпаковку()
	
	Для каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
		Если НЕ ТекСтрока.Выбрано Тогда
			Продолжить;
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Ссылка.Номенклатура) ИЛИ НЕ ЗначениеЗаполнено(ТекСтрока.ШтрихкодДляПоиска) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Штрихкод.Установить(ТекСтрока.ШтрихкодДляПоиска); 
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() Тогда
			НоваяЗапись = НаборЗаписей[0];
			НоваяЗапись.Упаковка = ТА_ОбщегоНазначения.ПодобратьУпаковкуПоКоличеству(НоваяЗапись.Номенклатура, НоваяЗапись.ТА_Количество); 
			Если НЕ ЗначениеЗаполнено(НоваяЗапись.Упаковка) Тогда
				НоваяЗапись.Упаковка = ТА_ОбщегоНазначения.СоздатьУпаковкуПоКоличеству(НоваяЗапись.Номенклатура, НоваяЗапись.ТА_Количество);
			КонецЕсли;
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_ВыделитьВсе(Команда)
	
	ВыделенныеСтроки = Элементы.ТЗ_ОшибкиВАгрегациях.ВыделенныеСтроки;

	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		ТЗ_ОшибкиВАгрегациях.НайтиПоИдентификатору(ТекСтрока).Выбрано = Истина;    
	КонецЦикла;
	 
	//Для Каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
	//	ТекСтрока.Выбрано = Истина;
	//КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегации_СнятьВыделение(Команда)
	Для Каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
		ТекСтрока.Выбрано = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_ЗаполнитьРегистрыКМНаОснованииСправочника(Команда)
	ОшибкиВАгрегациях_ЗаполнитьРегистрыКМНаОснованииСправочникаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОшибкиВАгрегациях_ЗаполнитьРегистрыКМНаОснованииСправочникаНаСервере()
	
	Для каждого ТекСтрока Из ТЗ_ОшибкиВАгрегациях Цикл
		
		Если НЕ ТекСтрока.Выбрано Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ТА_СоставАгрегации.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Агрегация.Установить(ТекСтрока.ШтрихкодДляПоиска); 
		НовыйИдентификатор = Новый УникальныйИдентификатор();

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Штрихкод КАК Штрихкод
		               |ИЗ
		               |	Справочник.ШтрихкодыУпаковокТоваров.ВложенныеШтрихкоды КАК ШтрихкодыУпаковокТоваровВложенныеШтрихкоды
		               |ГДЕ
		               |	ШтрихкодыУпаковокТоваровВложенныеШтрихкоды.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ТекСтрока.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяЗапись = НаборЗаписей.Добавить(); 
			НоваяЗапись.Идентификатор = НовыйИдентификатор; 
			НоваяЗапись.Агрегация = ТекСтрока.ШтрихкодДляПоиска; 
			НоваяЗапись.КодМаркировки = Выборка.Штрихкод;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
		Если ТекСтрока.КоличествоАСУСИЗ = 0 Тогда
			НовыйОбъект = Справочники.АСИЗ_ШтрихкодыУпаковокТоваров.СоздатьЭлемент();
			НовыйОбъект.ШтрихкодУпаковки = ТекСтрока.Ссылка;
			НовыйОбъект.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьРегистрТА_СоставАгрегации(Команда)
	
	ТекСтрока = Элементы.ТЗ_ОшибкиВАгрегациях.ТекущиеДанные;
	
	Отбор = Новый Структура("Агрегация", ТекСтрока.ШтрихкодДляПоиска);  
	ОткрытьФорму("РегистрСведений.ТА_СоставАгрегации.ФормаСписка", Новый Структура("Отбор", Отбор));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистрШтрихкодыНоменклатуры(Команда)
	
	ТекСтрока = Элементы.ТЗ_ОшибкиВАгрегациях.ТекущиеДанные;
	
	Отбор = Новый Структура("Штрихкод", ТекСтрока.ШтрихкодДляПоиска);  
	ОткрытьФорму("РегистрСведений.ШтрихкодыНоменклатуры.ФормаСписка", Новый Структура("Отбор", Отбор));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСправочникАСУСИЗ(Команда)
	
	ТекСтрока = Элементы.ТЗ_ОшибкиВАгрегациях.ТекущиеДанные;
	
	Отбор = Новый Структура("ШтрихкодУпаковки", ТекСтрока.Ссылка);  
	ОткрытьФорму("Справочник.АСИЗ_ШтрихкодыУпаковокТоваров.ФормаСписка", Новый Структура("Отбор", Отбор));
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиНСИ_Заполнить(Команда)
	ОшибкиНСИ_ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОшибкиНСИ_ЗаполнитьНаСервере()
	
	ОбъектТЗ_ОшибкиНСИ = РеквизитФормыВЗначение("ТЗ_ОшибкиНСИ");
	ОбъектТЗ_ОшибкиНСИ.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НоменклатураДополнительныеРеквизиты.Ссылка.Артикул КАК Артикул,
	               |	НоменклатураДополнительныеРеквизиты.Ссылка КАК Номенклатура,
	               |	НоменклатураДополнительныеРеквизиты.Ссылка.ВестиУчетПоГТД КАК ВестиУчетПоГТД,
	               |	НоменклатураДополнительныеРеквизиты.Значение КАК СтранаПроисхождения,
	               |	ЛОЖЬ КАК Выбрано,
	               |	""Установлен признак """"вести учет по номерам ГТД"""" у отечественных товаров"" КАК ОписаниеОшибки
	               |ИЗ
	               |	Справочник.Номенклатура.ДополнительныеРеквизиты КАК НоменклатураДополнительныеРеквизиты
	               |ГДЕ
	               |	НоменклатураДополнительныеРеквизиты.Свойство = &Свойство
	               |	И НоменклатураДополнительныеРеквизиты.Значение = &Значение
	               |	И НоменклатураДополнительныеРеквизиты.Ссылка.ВестиУчетПоГТД = ИСТИНА";
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Страна происхождения (Справочник ""Номенклатура"" (Общие))"));
	Запрос.УстановитьПараметр("Значение", Справочники.СтраныМира.Россия);
	
	ОбъектТЗ_ОшибкиНСИ = Запрос.Выполнить().Выгрузить();
	КоличествоОшибок = ОбъектТЗ_ОшибкиНСИ.Количество();
	
	ЗначениеВРеквизитФормы(ОбъектТЗ_ОшибкиНСИ, "ТЗ_ОшибкиНСИ");
	
	//Элементы.ГруппаНеверныеАгрегации.Заголовок = ?(КоличествоОшибок = 0, "Ошибки в агрегациях", СтрШаблон("Ошибки в агрегациях (%1)", КоличествоОшибок));
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиНСИ_ВыделитьВсе(Команда)
	
	ВыделенныеСтроки = Элементы.ТЗ_ОшибкиНСИ.ВыделенныеСтроки;

	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		ТЗ_ОшибкиНСИ.НайтиПоИдентификатору(ТекСтрока).Выбрано = Истина;    
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиНСИ_СнятьВыделение(Команда)
	Для Каждого ТекСтрока Из ТЗ_ОшибкиНСИ Цикл
		ТекСтрока.Выбрано = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиНСИ_ИсправитьФлагВестиУчетПоГТД(Команда)
	ОшибкиНСИ_ИсправитьФлагВестиУчетПоГТДНаСервере();
	ОшибкиНСИ_ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОшибкиНСИ_ИсправитьФлагВестиУчетПоГТДНаСервере()
	
	Сч = 0;
	Для каждого ТекСтрока Из ТЗ_ОшибкиНСИ Цикл
		Если НЕ ТекСтрока.Выбрано Тогда
			Продолжить;
		КонецЕсли;
		
		НоменклатураОбъект = ТекСтрока.Номенклатура.ПолучитьОбъект();
		НоменклатураОбъект.ВестиУчетПоГТД = Ложь;
		
		Попытка
			НоменклатураОбъект.Записать();
		Исключение
			Прервать;
		КонецПопытки;
		
		Сч = Сч + 1;
	КонецЦикла;
	
	Сообщить(СтрШаблон("Обработано %1 строк", Сч));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьГрупповоеИзменениеРеквизитов(Команда)
	
	//Помещаем обработку во временном хранилище
    АдресХранилища = "";
    Результат = ПоместитьФайл(АдресХранилища, "V:\Общая папка\Ведерников\Обработки\ГрупповоеИзменениеРеквизитов.epf", , Ложь);           
    ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища);
    
    // Откроем форму подключенной внешней обработки
    ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРоли_КомуНазначенаРоль(Команда)
	
	ОчиститьСообщения();
	ГруппаРоли_КомуНазначенаРольНаСервере();
	
КонецПроцедуры

Процедура ГруппаРоли_КомуНазначенаРольНаСервере()
	
	СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Роль = ГруппаРоли_Роль;
	Для Каждого Пользователь из СписокПольЗователей Цикл 
	    Если Пользователь.Роли.Содержит(Метаданные.Роли[Роль.Имя])Тогда
	        Сообщить(Пользователь.Имя); 
	    КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьАнализЖурналаРегистрации(Команда)
	ПараметрыФормы = Новый Структура("СформироватьПриОткрытии", Истина);
	ОткрытьФорму("Отчет.АнализЖурналаРегистрации.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРоли_КакимПрофилямНазначенаРоль(Команда)
	
	ОчиститьСообщения();
	ГруппаРоли_КакимПрофилямНазначенаРольНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ГруппаРоли_КакимПрофилямНазначенаРольНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПрофилиГруппДоступаРоли.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
	               |ГДЕ
	               |	ПрофилиГруппДоступаРоли.Роль = &Роль
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПрофилиГруппДоступаРоли.Ссылка";
	Запрос.УстановитьПараметр("Роль", ГруппаРоли_Роль);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Сообщить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьГУИДПоСсылке(Команда)
	ОбщегоНазначенияКлиент.СообщитьПользователю(ПолучитьГУИДПоСсылке_Ссылка.УникальныйИдентификатор());
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьанализПравДоступа(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОшибкиВАгрегациях_СоздатьУпаковку(Команда)
	
	ОшибкиВАгрегациях_СоздатьИндивидуальнуюУпаковку();
	ОшибкиВАгрегациях_ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаданияКРасчетуСебестоимости(Команда)
	ОткрытьФорму("РегистрСведений.ЗаданияКРасчетуСебестоимости.ФормаСписка");
КонецПроцедуры

#КонецОбласти
