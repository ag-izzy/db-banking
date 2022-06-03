Config = {}

Config.BankZones = {}

Config.ATMS = {
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`,
}

Config.TargetName = 'qb-target' -- Name of your qtarget / bt-target / qb-target

Config.Framework = 'qb' -- esx / qb

Config.Language = 'lt'
Config.Locales = {
    ['lt'] = {
        ['open_atm'] = 'Atidaryti bankomatą',
        ['open_bank'] = 'Atidaryti banko meniu',
        ['withdrew'] = 'Išsigrynino.',
        ['deposited'] = 'Įnešė.',
        ['from'] = 'iš',
        ['to'] = '',
    },
    ['en'] = {
        ['open_atm'] = 'Open ATM',
        ['open_bank'] = 'Open bank',
        ['withdrew'] = 'Withdrew.',
        ['deposited'] = 'Deposited.',
        ['from'] = 'from',
        ['to'] = 'to',
    }
}