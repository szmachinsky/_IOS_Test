//
//  SZMTaxi.m
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZMTaxi.h"

@interface SZMTaxi ()
//@property (nonatomic) NSString *name;
//@property (nonatomic) NSString *shortNumber;           
//@property (nonatomic) NSString *description;
//@property (nonatomic) NSString *tarifs;
//@property (nonatomic) NSMutableDictionary *numbers;
@end

@implementation SZMTaxi
{
    NSString *name_;
    NSString *shortNumber_;
    NSString *description_;
    NSString *tarifs_;
    NSArray *operators_;
    NSDictionary *numbers_;
}
@synthesize name = name_;
@synthesize shortNumber = shortNumber_;
@synthesize description = description_;
@synthesize tarifs = tarifs_;
@synthesize operators = operators_;
@synthesize numbers = numbers_;


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
//------------------------------------------------------------------------------

+ (SZMTaxi*)addTaxi:(NSString*)tname shortNumber:(NSString*)snum
{
    SZMTaxi *res = [[SZMTaxi alloc] init];
    res.name = tname;
    res.shortNumber = snum;
    res.description = @"бла-бла-бла";
    res.tarifs = @" посадка - 2000. 1 км - 2500, ночью - 3500";
    NSArray *oper = [NSArray arrayWithObjects:@"Velcom", @"MTC", @"Life :)", @"Городской", nil];
    res.operators = oper;
    NSArray *velc = [NSArray arrayWithObjects:@"+375-29-111-22-33", @"+375-29-112-22-33", @"+375-29-113-22-33", nil]; 
    NSArray *mtc = [NSArray arrayWithObjects:@"+375-29-222-22-33", @"+375-29-222-22-33", nil]; 
    NSArray *life = [NSArray arrayWithObjects:@"+375-29-333-22-33", nil]; 
    NSArray *_sity_ = [NSArray arrayWithObjects:@"+375-17-444-22-33", nil];
    NSArray *tels = [NSArray arrayWithObjects:velc, mtc,life,_sity_, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:tels forKeys:oper];
    res.numbers = dic;
    
    return res;
}


+ (SZMTaxi*)addTaxi1
{
    SZMTaxi *res = [[SZMTaxi alloc] init];
    res.name = @"Такси 'Минские автолинии'";
    res.shortNumber = @"157";
    res.description = @"Вам нужно в рекордные сроки добраться до офиса, домой, торгового или развлекательного центра, аэропорта, вокзала, гостиницы? Встретить, безопасно и с комфортом проводить поздним вечером своих родственников и друзей, что-то передать, никогда не опаздывать, приезжать на работу в хорошем настроении? Позвоните нам, и Вас всегда порадуют приемлемые цены и отличный сервис.";
    res.tarifs = @" ";
    NSArray *oper = [NSArray arrayWithObjects:@"Velcom", @"MTC", nil];
    res.operators = oper;
    NSArray *velc = [NSArray arrayWithObjects:@"+375-29-666-9-057", nil]; 
    NSArray *mtc = [NSArray arrayWithObjects:@"+375-29-777-9-057", nil]; 
//    NSArray *life = [NSArray arrayWithObjects:@"+375-29-333-22-33", nil]; 
//    NSArray *_sity_ = [NSArray arrayWithObjects:@"+375-17-444-22-33", nil];
    NSArray *tels = [NSArray arrayWithObjects:velc, mtc, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:tels forKeys:oper];
    res.numbers = dic;
        
    return res;
}

+ (SZMTaxi*)addTaxi2
{
    SZMTaxi *res = [[SZMTaxi alloc] init];
    res.name = @"Такси 'Алмаз'";
    res.shortNumber = @"7788";
    res.description = @"Перевозка пассажиров автомобилями «Такси Алмаз» в городе Минске и на расстояние 30 км от МКАД; Перевозка небольших грузов; Обслуживание праздников; Трансфер в Национальный аэропорт Минск-2; Эвакуация";
    res.tarifs = @"тариф: 1 км - 3100 руб";
    NSArray *oper = [NSArray arrayWithObjects:@"Velcom", @"MTC", @"Городской", nil];
    res.operators = oper;
    NSArray *velc = [NSArray arrayWithObjects:@"7788", nil]; 
    NSArray *mtc = [NSArray arrayWithObjects:@"7788", nil]; 
//    NSArray *life = [NSArray arrayWithObjects:@"", nil]; 
    NSArray *_sity_ = [NSArray arrayWithObjects:@"+375-17-306-07-78", nil];
    NSArray *tels = [NSArray arrayWithObjects:velc, mtc,_sity_, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:tels forKeys:oper];
    res.numbers = dic;
    
    return res;
}

+ (SZMTaxi*)addTaxi3
{
    SZMTaxi *res = [[SZMTaxi alloc] init];
    res.name = @"Tакси 'Престиж'";
    res.shortNumber = nil;
    res.description = @"бла-бла-бла";
    res.tarifs = @" ";
    NSArray *oper = [NSArray arrayWithObjects:@"Velcom", @"MTC", @"Life :)", nil];
    res.operators = oper;
    NSArray *velc = [NSArray arrayWithObjects:@"+375-29-333-30-01", @"+375-29-666-60-01", nil]; 
    NSArray *mtc = [NSArray arrayWithObjects:@"+375-29-222-20-01", @"+375-29-777-70-01", nil]; 
    NSArray *life = [NSArray arrayWithObjects:@"+375-29-999-90-01", nil]; 
//    NSArray *_sity_ = [NSArray arrayWithObjects:@"+375-17-444-22-33", nil];
    NSArray *tels = [NSArray arrayWithObjects:velc, mtc,life, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:tels forKeys:oper];
    res.numbers = dic;
    
    return res;
}




@end



