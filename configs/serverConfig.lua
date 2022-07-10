Auth = exports.plouffe_lib:Get("Auth")
Callback = exports.plouffe_lib:Get("Callback")

Server = {
	Init = false,
    not_used_interiors = {
        playerhouse_hotel = {
            hash = GetHashKey("playerhouse_hotel"),
            index = "playerhouse_hotel"
        },
        playerhouse_tier1 = {
            hash = GetHashKey("playerhouse_tier1"),
            index = "playerhouse_tier1"
        },
    }
}

House = {}
HouseFnc = {} 

House.JobPercentOnSales = 10
House.BreachPrice = 10000

House.Breached = {}
House.Houses = {}
House.Player = {}

House.Maximums = {
    inventory = 3,
    wardrobe = 3
}

House.AllowedToAddDoors = {
    realestateagent = {["3"] = true}
}

House.RaidJobs = {
    police = {
        ["5"] = true,
        ["6"] = true,
        ["7"] = true
    }
}

House.RaidJobsInventory = {
    police = {
        ["7"] = true
    }
}

House.Job = {
    realestateagent = {["2"] = true, ["3"] = true}
}

House.Interiors = {
    shell_office1 = {
        hash = GetHashKey("shell_office1"),
        index = "shell_office1",
        type = "office",
        label = "Bureau Moderne 1"
    },
    shell_office2 = {
        hash = GetHashKey("shell_office2"),
        index = "shell_office2",
        type = "office",
        label = "Bureau luxueux en bois"
    },
    shell_officebig = {
        hash = GetHashKey("shell_officebig"),
        index = "shell_officebig",
        type = "office",
        label = "Très grand bureau"
    },
    shell_garages = {
        hash = GetHashKey("shell_garages"),
        index = "shell_garages",
        type = "garage",
        label = "Garage petit"
    },
    shell_garagem = {
        hash = GetHashKey("shell_garagem"),
        index = "shell_garagem",
        type = "garage",
        label = "Garage medium"
    },
    shell_garagel = {
        hash = GetHashKey("shell_garagel"),
        index = "shell_garagel",
        type = "garage",
        label = "Garage grand"
    },
    stashhouse3_shell = {
        hash = GetHashKey("stashhouse3_shell"),
        index = "stashhouse3_shell",
        type = "warehouse",
        label = "Petite grange (Meubler)"
    },
    stashhouse2_shell = {
        hash = GetHashKey("stashhouse2_shell"),
        index = "stashhouse2_shell",
        type = "warehouse",
        label = "Petite grange"
    },
    shell_warehouse1 = {
        hash = GetHashKey("shell_warehouse1"),
        index = "shell_warehouse1",
        type = "warehouse",
        label = "Gros entrepot"
    },
    shell_warehouse2 = {
        hash = GetHashKey("shell_warehouse2"),
        index = "shell_warehouse2",
        type = "warehouse",
        label = "Très gros entrepot 1"
    },
    stashhouse1_shell = {
        hash = GetHashKey("stashhouse1_shell"),
        index = "stashhouse1_shell",
        type = "warehouse",
        label = "Très gros entrepot 1 (Meubler)"
    },
    stashhouse_shell = {
        hash = GetHashKey("stashhouse_shell"),
        index = "stashhouse_shell",
        type = "warehouse",
        label = "Très gros entrepot 2"
    },
    shell_weed = {
        hash = GetHashKey("shell_weed"),
        index = "shell_weed",
        type = "warehouse",
        label = "Fabrication de weed (Vide)"
    },
    shell_weed2 = {
        hash = GetHashKey("shell_weed2"),
        index = "shell_weed2",
        type = "warehouse",
        label = "Fabrication de weed (Meubler)"
    },
    shell_warehouse3 = {
        hash = GetHashKey("shell_warehouse3"),
        index = "shell_warehouse3",
        type = "warehouse",
        label = "Petit entrepot"
    },
    shell_coke2 = {
        hash = GetHashKey("shell_coke2"),
        index = "shell_coke2",
        type = "warehouse",
        label = "Fabrication de coke (Meubler)"
    },
    shell_coke1 = {
        hash = GetHashKey("shell_coke1"),
        index = "shell_coke1",
        type = "warehouse",
        label = "Fabrication de coke (Vide)"
    },
    shell_meth = {
        hash = GetHashKey("shell_meth"),
        index = "shell_meth",
        type = "warehouse",
        label = "fabrication de meth"
    },
    shell_store1 = {
        hash = GetHashKey("shell_store1"),
        index = "shell_store1",
        type = "store",
        label = "Ammunation"
    },
    shell_gunstore = {
        hash = GetHashKey("shell_gunstore"),
        index = "shell_gunstore",
        type = "store",
        label = "Ammunation 2"
    },
    shell_store2 = {
        hash = GetHashKey("shell_store2"),
        index = "shell_store2",
        type = "store",
        label = "Pawn Shop"
    },
    shell_barber = {
        hash = GetHashKey("shell_barber"),
        index = "shell_barber",
        type = "store",
        label = "Barbier"
    },
    shell_store3 = {
        hash = GetHashKey("shell_store3"),
        index = "shell_store3",
        type = "store",
        label = "Standard"
    },
    shell_v16low = {
        hash = GetHashKey("shell_v16low"),
        index = "shell_v16low",
        type = "house",
        label = "Très petite maison 1 (Standard)"
    },
    shell_trailer = {
        hash = GetHashKey("shell_trailer"),
        index = "shell_trailer",
        type = "house",
        label = "Maison mobile 1"
    },
    shell_v16mid = {
        hash = GetHashKey("shell_v16mid"),
        index = "shell_v16mid",
        type = "house",
        label = "Petite maison 1 (Standard)"
    },
    shell_medium2 = {
        hash = GetHashKey("shell_medium2"),
        index = "shell_medium2",
        type = "house",
        label = "Petite maison 2 (Standard)"
    },
    shell_trevor = {
        hash = GetHashKey("shell_trevor"),
        index = "shell_trevor",
        type = "house",
        label = "Petite maison (trevor)"
    },
    shell_frankaunt = {
        hash = GetHashKey("shell_frankaunt"),
        index = "shell_frankaunt",
        type = "house",
        label = "Petite maison (Franklin)"
    },
    shell_lester = {
        hash = GetHashKey("shell_lester"),
        index = "shell_lester",
        type = "house",
        label = "Petite maison (Lester)"
    },
    shell_medium3 = {
        hash = GetHashKey("shell_medium3"),
        index = "shell_medium3",
        type = "house",
        label = "Moyenne maison (Extra Bs)"
    },
    shell_michael = {
        hash = GetHashKey("shell_michael"),
        index = "shell_michael",
        type = "luxury",
        label = "Maison 1 (Michael)"
    },
    shell_ranch = {
        hash = GetHashKey("shell_ranch"),
        index = "shell_ranch",
        type = "luxury",
        label = "Ranch (Fuente blanca)"
    },
    shell_apartment1 = {
        hash = GetHashKey("shell_apartment1"),
        index = "shell_apartment1",
        type = "luxury",
        label = "Maison / Condo 2 (3 Etage) Couleur 1"
    },
    shell_apartment2 = {
        hash = GetHashKey("shell_apartment2"),
        index = "shell_apartment2",
        type = "luxury",
        label = "Maison / Condo 2 (3 Etage) Couleur 2"
    },
    shell_apartment3 = {
        hash = GetHashKey("shell_apartment3"),
        index = "shell_apartment3",
        type = "luxury",
        label = "Maison / Condo 3 (2 Etage)"
    },
    shell_highend = {
        hash = GetHashKey("shell_highend"),
        index = "shell_highend",
        type = "luxury",
        label = "Maison / Condo 1 (2 Etage)"
    },
    shell_highendv2 = {
        hash = GetHashKey("shell_highendv2"),
        index = "shell_highendv2",
        type = "luxury",
        label = "Maison / Condo 2 (1 Etage)"
    },
    modernhotel_shell = {
        hash = GetHashKey("modernhotel_shell"),
        index = "modernhotel_shell",
        type = "room",
        label = "Chambre moderne 1"
    },
    modernhotel2_shell = {
        hash = GetHashKey("modernhotel2_shell"),
        index = "modernhotel2_shell",
        type = "room",
        label = "Chambre moderne 2"
    },
    modernhotel3_shell = {
        hash = GetHashKey("modernhotel3_shell"),
        index = "modernhotel3_shell",
        type = "room",
        label = "Chambre moderne 3"
    },
    container_shell = {
        hash = GetHashKey("container_shell"),
        index = "container_shell",
        type = "container",
        label = "Conteneur vide 1"
    },
    container2_shell = {
        hash = GetHashKey("container2_shell"),
        index = "container2_shell",
        type = "container",
        label = "Conteneur armement (meubler)"
    }
}

House.OffSets = {
    shell_office1 = {
        default = {
            coords = vector3(1.216309, 4.927734, -0.7255096)
        },
    },
    shell_office2 = {
        default = {
            coords = vector3(3.15625, -1.869385, -0.8748779)
        },
    },
    shell_officebig = {
        default = {
            coords = vector3(-12.53296, 1.987793, -0.398412)
        },
    },
    shell_garages = {
        default = {
            coords = vector3(5.860107, 3.570068, -0.5000267)
        },
    },
    shell_garagem = {
        default = {
            coords = vector3(13.61621, 1.550537, -0.7500381)
        },
    },
    shell_garagel = {
        default = {
            coords = vector3(12.01221, -14.10425, -1.000107)
        },
    },
    stashhouse3_shell = {
        default = {
            coords = vector3(0.04614258, 5.133301, -1.011681)
        },
    },
    stashhouse2_shell = {
        default = {
            coords = vector3(-1.842285, 2.115234, -1.011707)
        },
    },
    shell_warehouse1 = {
        default = {
            coords = vector3(-8.439819, 0.02926636, -0.9492455)
        },
    },
    shell_warehouse2 = {
        default = {
            coords = vector3(-12.13782, 5.449646, -2.059053)
        },
    },
    stashhouse1_shell = {
        default = {
            coords = vector3(20.57935, -0.621582, -2.070862)
        },
    },
    stashhouse_shell = {
        default = {
            coords = vector3(20.60248, -0.09606934, -2.070835)
        },
    },
    shell_weed = {
        default = {
            coords = vector3(17.21814, 11.66107, -2.096981)
        },
    },
    shell_weed2 = {
        default = {
            coords = vector3(17.3269, 11.66972, -2.096977)
        },
    },
    shell_warehouse3 = {
        default = {
            coords = vector3(2.103271, -1.625916, -0.9429626)
        },
    },
    shell_coke2 = {
        default = {
            coords = vector3(-6.238037, 8.143799, -0.9585228)
        },
    },
    shell_coke1 = {
        default = {
            coords = vector3(-6.228088, 8.121124, -0.9585953)
        },
    },
    shell_meth = {
        default = {
            coords = vector3(-6.180603, 8.247498, -0.9585495)
        },
    },
    shell_store1 = {
        default = {
            coords = vector3(-2.693481, 4.159149, -0.6197052)
        },
    },
    shell_gunstore = {
        default = {
            coords = vector3(-1.148987, -4.958405, -0.7365875)
        },
    },
    shell_store2 = {
        default = {
            coords = vector3(-0.7619019, -4.602295, -1.153385)
        },
    },
    shell_barber = {
        default = {
            coords = vector3(1.679749, 5.121033, -0.5571404)
        },
    },
    shell_store3 = {
        default = {
            coords = vector3(-0.007873535, -7.2771, -0.300993)
        },
    },
    shell_v16low = {
        default = {
            coords = vector3(4.746765, -6.239502, -1.654236)
        },
    },
    shell_trailer = {
        default = {
            coords = vector3(-1.477905, -1.806152, -0.4796448)
        },
    },
    shell_v16mid = {
        default = {
            coords = vector3(1.357239, -13.84534, -0.4923248)
        },
    },
    shell_medium2 = {
        default = {
            coords = vector3(6.027161, 0.6832275, -0.6609917)
        },
    },
    shell_trevor = {
        default = {
            coords = vector3(0.2979126, -3.524292, -0.4080439)
        },
    },
    shell_frankaunt = {
        default = {
            coords = vector3(-0.3928223, -5.408203, -0.5699387)
        },
    },
    shell_lester = {
        default = {
            coords = vector3(-1.656921, -5.493774, -0.3696899)
        },
    },
    shell_medium3 = {
        default = {
            coords = vector3(5.539795, -1.599365, 1.204891)
        },
    },
    shell_michael = {
        default = {
            coords = vector3(-9.029297, 5.619385, -4.063694)
        },
    },
    shell_ranch = {
        default = {
            coords = vector3(-1.013611, -5.434326, -1.263245)
        },
    },
    shell_apartment1 = {
        default = {
            coords = vector3(-2.230164, 8.3479, 3.202423)
        },
    },
    shell_apartment2 = {
        default = {
            coords = vector3(-2.173462, 8.536987, 3.202377)
        },
    },
    shell_apartment3 = {
        default = {
            coords = vector3(11.43082, 4.30481, 2.009698)
        },
    },
    shell_highend = {
        default = {
            coords = vector3(-21.88211, -0.3710938, 7.2075)
        },
    },
    shell_highendv2 = {
        default = {
            coords = vector3(-9.827209, 0.998291, 1.935001)
        },
    },
    modernhotel_shell = {
        default = {
            coords = vector3(5.013794, 3.86792, -0.8178482)
        },
    },
    modernhotel2_shell = {
        default = {
            coords = vector3(5.051086, 3.755493, -0.8214417)
        },
    },
    modernhotel3_shell = {
        default = {
            coords = vector3(4.917206, 3.690063, -0.8212986)
        },
    },
    container_shell = {
        default = {
            coords = vector3(-0.06896973, -5.18103, -0.2136211)
        },
    },
    container2_shell = {
        default = {
            coords = vector3(0.01937866, -5.220093, -0.2136688)
        }
    }
}

House.Menu = {
    new_confirm_entry = {
        {
            id = 1,
            header = "Etes vous certain de confirmer l'emplacement",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Va confirmer l'emplacement",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Continuer a placer",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    furniture_menu_delete_or_add = {
        {
            id = 1,
            header = "Ajouter des meubles",
            txt = "Acheter des meubles",
            params = {
                event = "",
                args = {
                    fnc = "StartPropPlacer"
                }
            }
        },
        {
            id = 2,
            header = "Retirer des meubles",
            txt = "Vendre des meubles",
            params = {
                event = "",
                args = {
                    fnc = "StartDeleteProp"
                }
            }
        },
        {
            id = 3,
            header = "Fermer",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    confirm_sell_funrniture = {
        {
            id = 1,
            header = "Etes vous certain de vouloir vendre ce meuble",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Vendre",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    confirm_wardrobe_placement = {
        {
            id = 1,
            header = "Etes vous certain de vouloir placer un garde-robe ici",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Placer le garde-robe",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    confirm_inventory_placement = {
        {
            id = 1,
            header = "Etes vous certain de vouloir placer un inventaire ici",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Placer l'inventaire",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    confirm_destroy = {
        {
            id = 1,
            header = "Etes vous certain de vouloir detruire cette maison",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Va detruire la maison",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Ferme le menu",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    cancel_creator = {
        {
            id = 1,
            header = "Etes vous certain de vouloir annuler la création ?",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Va annuler la création",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Continuer la création",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    confirm_entry = {
        {
            id = 1,
            header = "Etes vous certain de confirmer l'emplacement",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Va confirmer l'emplacement de l'entré",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Continuer a placer l'entré",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
	confirm_shell = {
        {
            id = 1,
            header = "Etes vous certain de confirmer l'emplacement",
            txt = "Appuier sur OUI pour confirmer",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "OUI",
            txt = "Va confirmer l'emplacement de l'intérieur",
            params = {
                event = "",
                args = {
                    confirm = true
                }
            }
        },
        {
            id = 3,
            header = "NON",
            txt = "Continuer a placer l'intérieur",
            params = {
                event = "",
                args = {
                }
            }
        }
    },
    shell_types = {
        {
            id = 1,
            header = "Liste de style d'intérieur possible",
            txt = "Veullez choisir un style",
            params = {
                event = "",
                args = {
                }
            }
        },
        {
            id = 2,
            header = "Bureau",
            txt = "Voir la liste des bureau",
            params = {
                event = "",
                args = {
                    shell_type = "office"
                }
            }
        },
        {
            id = 3,
            header = "Garage",
            txt = "Voir la liste des garages",
            params = {
                event = "",
                args = {
                    shell_type = "garage"
                }
            }
        },
        {
            id = 4,
            header = "Entrepot",
            txt = "Voir la liste des entrepots",
            params = {
                event = "",
                args = {
                    shell_type = "warehouse"
                }
            }
        },
        {
            id = 5,
            header = "Magasin",
            txt = "Voir la liste des magasins",
            params = {
                event = "",
                args = {
                    shell_type = "store"
                }
            }
        },
        {
            id = 6,
            header = "Maison",
            txt = "Voir la liste des maisons",
            params = {
                event = "",
                args = {
                    shell_type = "house"
                }
            }
        },
        {
            id = 7,
            header = "Maison / Condo de luxe",
            txt = "Voir la liste des maisons et condos de luxe",
            params = {
                event = "",
                args = {
                    shell_type = "luxury"
                }
            }
        },
        {
            id = 8,
            header = "Chambre",
            txt = "Voir la liste des chambres",
            params = {
                event = "",
                args = {
                    shell_type = "room"
                }
            }
        },
        {
            id = 9,
            header = "Conteneur",
            txt = "Voir la liste des conteneur",
            params = {
                event = "",
                args = {
                    shell_type = "container"
                }
            }
        }
    },
    props_type = {
        {
            id = 1,
            header = "Divan",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "couches"
                }
            }
        },
        {
            id = 2,
            header = "Chaise",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "chairs"
                }
            }
        },
        {
            id = 3,
            header = "Lits",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "beds"
                }
            }
        },
        {
            id = 4,
            header = "General 1",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "general_1"
                }
            }
        },
        {
            id = 5,
            header = "General 2",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "general_2"
                }
            }
        },
        {
            id = 6,
            header = "General 3",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "general_3"
                }
            }
        },
        {
            id = 7,
            header = "General 4",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "general_4"
                }
            }
        },
        {
            id = 8,
            header = "Petit objects",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "small"
                }
            }
        },
        {
            id = 9,
            header = "Rangement",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "storage"
                }
            }
        },
        {
            id = 10,
            header = "Electroniques",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "electronics"
                }
            }
        },
        {
            id = 11,
            header = "Éclairage",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "lighting"
                }
            }
        },
        {
            id = 12,
            header = "Tables",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "tables"
                }
            }
        },
        {
            id = 13,
            header = "Plantes",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "plants"
                }
            }
        },
        {
            id = 14,
            header = "Cuisine",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "kitchen"
                }
            }
        },
        {
            id = 15,
            header = "Sale de bain",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "bathroom"
                }
            }
        },
        {
            id = 16,
            header = "Médicale",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "medical"
                }
            }
        },
        {
            id = 17,
            header = "Illégaux",
            txt = "Appuier pour voir la liste",
            params = {
                event = "",
                args = {
                    type = "criminal"
                }
            }
        }
    }
}

House.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
    blips = {}
}

House.Zones = {
    -- housing_call_agent = {
	-- 	name = "housing_call_agent",
	-- 	coords = vector3(-72.80241394043, -815.99499511719, 243.38595581055),
	-- 	maxDst = 2.0,
	-- 	protectEvents = true,
	-- 	isKey = true,
	-- 	isZone = true,
    --     isPed = true,
	-- 	nuiLabel = "Appeller un agent immobilier",
    --     aditionalParams = {fnc = "CallSellAgent"},
	-- 	keyMap = {
	-- 		checkCoordsBeforeTrigger = true,
	-- 		onRelease = true,
	-- 		releaseEvent = "plouffe_housing:on_zones",
	-- 		key = "E"
	-- 	},
    --     pedInfo = {
    --         coords = vector3(-72.193862915039, -814.37066650391, 243.38595581055),
    --         heading = 163.9765777587891,
    --         model = "a_f_y_business_01",
    --         scenario = "WORLD_HUMAN_COP_IDLES",
    --         pedId = 0
    --     }
	-- }
}

House.Creator = {
    canceled = false,
    settingCoords = false,
    inCreator = false,
    disable_controls = true,
    prop_id = 0,
    cam = nil,
    currentSpeed = 0.1,
    angleZ = 0.0,
    angleY = 0.0,
    camHeight = 10.0,
    createdHouse = {
        coords = {
            entrance =  {
                {            
                    inside = vector3(0,0,0), -- This should be offSet
                    outside = vector3(0,0,0) -- This Should be Set By the player
                }
            }
        },
        metadata = {
            shell = "",
            coords = vector3(0,0,0),
        },
    },
    offSets = {
        x = 0.1,
        y = 0.1,
        z = 0.1,
        h = 0.5,
        pitch = 0.1, 
        roll = 0.1, 
        yaw = 0.5
    },
    keys = {
        ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
        ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
        ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
        ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
        ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
        ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
        ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
        ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
        ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118,
        ["WHEELUP"] = 17, ["WHEELDOWN"] = 16, ["RIGHTMOUSE"] = 222
    }
}

House.Deleter = {
    active = false,
    current_furni_index = 1
}

House.DoorAdder = {
    active = false,
    house_id = 0,
    next_door_label = "Intérieur",
    new_door = {
        inside = vector3(0,0,0),
        outside = vector3(0,0,0)
    }
}

House.GarageAdder = {
    active = false,
    house_id = 0
}

House.PropsPlacer = {
    active = false,
    currentSpeed = 0.1,
    camHeight = 1.0,
    currentItem = {},
    prop_id = 0,
    createdProps = {}
}

House.Props = {
    couches = {
        {model = GetHashKey("miss_rub_couch_01"), price = 100, name = "Old Flowered Couch" },
        {model = GetHashKey("prop_fib_3b_bench"), price = 250, name = "3 Seat Chair" },
        {model = GetHashKey("prop_ld_farm_chair01"), price = 90, name = "Old 1 Seat Couch" },
        {model = GetHashKey("prop_ld_farm_couch01"), price = 120, name = "Old 3 Seat Couch" },
        {model = GetHashKey("prop_ld_farm_couch02"), price = 100, name = "Old Striped Couch" },
        {model = GetHashKey("v_res_d_armchair"), price = 100, name = "Old 1 Seat Couch Yellow" },
        {model = GetHashKey("v_res_fh_sofa"), price = 500, name = "Corner Sofa" },
        {model = GetHashKey("v_res_mp_sofa"), price = 500, name = "Corner Sofa 2" },
        {model = GetHashKey("v_res_d_sofa"), price = 200, name = "Sofa 1" },
        {model = GetHashKey("v_res_j_sofa"), price = 200, name = "Sofa 2" },
        {model = GetHashKey("v_res_mp_stripchair"), price = 200, name = "Sofa 3" },
        {model = GetHashKey("v_res_m_h_sofa_sml"), price = 200, name = "Sofa 4" },
        {model = GetHashKey("v_res_r_sofa"), price = 200, name = "Sofa 5" },
        {model = GetHashKey("v_res_tre_sofa"), price = 200, name = "Sofa 6" },
        {model = GetHashKey("v_res_tre_sofa_mess_a"), price = 200, name = "Sofa 7" },
        {model = GetHashKey("v_res_tre_sofa_mess_b"), price = 200, name = "Sofa 8" },
        {model = GetHashKey("v_res_tre_sofa_mess_c"), price = 200, name = "Sofa 9" },
        {model = GetHashKey("v_res_tt_sofa"), price = 200, name = "Sofa 10" },
        {model = GetHashKey("prop_rub_couch02"), price = 720, name = "Sofa 11" },
        {model = GetHashKey("apa_mp_h_stn_foot_stool_02"), price = 50, name = "foot stool 1" },
        {model = GetHashKey("apa_mp_h_stn_foot_stool_01"), price = 50, name = "foot stool 2" }
    },

    chairs = {
        {model = GetHashKey("v_res_d_highchair"), price = 100, name = "High Chair" },
        {model = GetHashKey("v_res_fa_chair01"), price = 100, name = "Chair" },
        {model = GetHashKey("v_res_fa_chair02"), price = 100, name = "Chair" },
        {model = GetHashKey("v_res_fh_barcchair"), price = 100, name = "High Chair" },
        {model = GetHashKey("v_res_fh_dineeamesa"), price = 100, name = "Dine Chair 1" },
        {model = GetHashKey("v_res_fh_dineeamesb"), price = 100, name = "Dine Chair 2" },
        {model = GetHashKey("v_res_fh_dineeamesc"), price = 100, name = "Dine Chair 3" },
        {model = GetHashKey("v_res_fh_easychair"), price = 100, name = "Chair" },
        {model = GetHashKey("v_res_fh_kitnstool"), price = 100, name = "Stool" },
        {model = GetHashKey("v_res_fh_singleseat"), price = 100, name = "High Chair" },
        {model = GetHashKey("v_res_jarmchair"), price = 100, name = "Arm Chair" },
        {model = GetHashKey("v_res_j_dinechair"), price = 100, name = "Dining Chair" },
        {model = GetHashKey("v_res_j_stool"), price = 100, name = "Stool" },
        {model = GetHashKey("v_res_mbchair"), price = 100, name = "MB Chair" },
        {model = GetHashKey("v_res_m_armchair"), price = 100, name = "Arm Chair" },
        {model = GetHashKey("v_res_m_dinechair"), price = 100, name = "Dine Chair" },
        {model = GetHashKey("v_res_study_chair"), price = 100, name = "Study Chair" },
        {model = GetHashKey("v_res_trev_framechair"), price = 100, name = "Frame Chair" },
        {model = GetHashKey("v_res_tre_chair"), price = 100, name = "Chair" },
        {model = GetHashKey("v_res_tre_officechair"), price = 100, name = "Office Chair" },
        {model = GetHashKey("v_res_tre_stool"), price = 100, name = "Stool" },
        {model = GetHashKey("v_res_tre_stool_leather"), price = 100, name = "Stool Leather" },
        {model = GetHashKey("v_res_tre_stool_scuz"), price = 100, name = "Stool Scuz" },
        {model = GetHashKey("v_med_p_deskchair"), price = 100, name = "Desk Chair" },
        {model = GetHashKey("v_med_p_easychair"), price = 100, name = "Easy Chair" },
        {model = GetHashKey("v_med_whickerchair1"), price = 100, name = "Whicker Chair" },
        {model = GetHashKey("prop_direct_chair_01"), price = 100, name = "Direct Chair 1" },
        {model = GetHashKey("prop_direct_chair_02"), price = 100, name = "Direct Chair 2" },
        {model = GetHashKey("prop_yacht_lounger"), price = 100, name = "Yacht Seat 1" },
        {model = GetHashKey("prop_yacht_seat_01"), price = 100, name = "Yacht Seat 2" },
        {model = GetHashKey("prop_yacht_seat_02"), price = 100, name = "Yacht Seat 3" },
        {model = GetHashKey("prop_yacht_seat_03"), price = 100, name = "Yacht Seat 4" },
        {model = GetHashKey("v_ret_chair_white"), price = 100, name = "White Chair" },
        {model = GetHashKey("v_ret_chair"), price = 100, name = "Chair" },
        {model = GetHashKey("v_ret_ta_stool"), price = 100, name = "TA Stool" },
        {model = GetHashKey("prop_cs_office_chair"), price = 100, name = "Office Chair" },
    },

    beds = {
        {model = GetHashKey("v_res_d_bed"), price = 100, name = "D Bed" },  
        {model = GetHashKey("v_res_lestersbed"), price = 100, name = "L Bed" }, 
        {model = GetHashKey("v_res_mbbed"), price = 100, name = "MB Bed" }, 
        {model = GetHashKey("v_res_mdbed"), price = 100, name = "MD Bed" }, 
        {model = GetHashKey("v_res_msonbed"), price = 100, name = "Mason Bed" },  
        {model = GetHashKey("v_res_tre_bed1"), price = 100, name = "T Bed" }, 
        {model = GetHashKey("v_res_tre_bed2"), price = 100, name = "T Bed 2" }, 
        {model = GetHashKey("v_res_tt_bed"), price = 100, name = "TT Bed" },
        {model = GetHashKey("apa_mp_h_bed_double_08"), price = 100, name = "Double Bed" },  
        {model = GetHashKey("apa_mp_h_bed_double_09"), price = 100, name = "Double Bed 2" },
        {model = GetHashKey("apa_mp_h_bed_wide_05"), price = 100, name = "Double Bed 3" },
        {model = GetHashKey("apa_mp_h_bed_with_table_02"), price = 500, name = "Bed with table" },
        {model = GetHashKey("gr_prop_bunker_bed_01"), price = 500, name = "Single bed" },
    },

    general_1 = {
        {model = GetHashKey("v_corp_facebeanbag"), price = 100, name = "Bean Bag 1" },
        {model = GetHashKey("v_res_cherubvase"), price = 400, name = "White Vase" },
        {model = GetHashKey("v_res_d_paddedwall"), price = 100, name = "Padded Wall" },
        {model = GetHashKey("v_res_d_ramskull"), price = 100, name = "Item" },
        {model = GetHashKey("v_res_d_whips"), price = 100, name = "Whips" },
        {model = GetHashKey("v_res_fashmag1"), price = 100, name = "Mags" },
        {model = GetHashKey("v_res_fashmagopen"), price = 100, name = "Mags Open" },
        {model = GetHashKey("v_res_fa_magtidy"), price = 100, name = "Mag Tidy" },
        {model = GetHashKey("v_res_fa_yogamat002"), price = 100, name = "Yoga Mat 1" },
        {model = GetHashKey("v_res_fa_yogamat1"), price = 100, name = "Yoga Mat 2" },
        {model = GetHashKey("v_res_fh_aftershavebox"), price = 100, name = "Aftershave" },
        {model = GetHashKey("v_res_fh_flowersa"), price = 100, name = "Flowers" },
        {model = GetHashKey("v_res_fh_fruitbowl"), price = 100, name = "Fruitbowl" },
        {model = GetHashKey("v_res_fh_laundrybasket"), price = 100, name = "Laundry Basket" },
        {model = GetHashKey("v_res_fh_pouf"), price = 100, name = "Pouf" },
        {model = GetHashKey("v_res_fh_sculptmod"), price = 100, name = "Sculpture" },
        {model = GetHashKey("v_res_j_magrack"), price = 100, name = "Mag Rack" },
        {model = GetHashKey("v_res_jewelbox"), price = 100, name = "Jewel Box" },
        {model = GetHashKey("v_res_mbbin"), price = 100, name = "Bin" },
        {model = GetHashKey("v_res_mbowlornate"), price = 100, name = "Ornate Bowl" },
        {model = GetHashKey("v_res_mbronzvase"), price = 100, name = "Bronze Vase" },
        {model = GetHashKey("v_res_mchalkbrd"), price = 100, name = "Chalk Board" },
        {model = GetHashKey("v_res_mddresser"), price = 100, name = "Dresser" },
        {model = GetHashKey("v_res_mplinth"), price = 100, name = "Linth" },
        {model = GetHashKey("v_res_mp_ashtrayb"), price = 100, name = "Ashtray" },
        {model = GetHashKey("v_res_m_candle"), price = 100, name = "Candle" },
        {model = GetHashKey("v_res_m_candlelrg"), price = 100, name = "Candle Large" },
        {model = GetHashKey("v_res_m_kscales"), price = 100, name = "Scales" },
        {model = GetHashKey("v_res_tt_bedpillow"), price = 100, name = "Bed Pillow" },
        {model = GetHashKey("apa_p_h_acc_artwallm_04"), price = 100, name = "Wall Art 1" },
        {model = GetHashKey("apa_p_h_acc_artwallm_03"), price = 100, name = "Wall Art 2" },
        {model = GetHashKey("apa_p_h_acc_artwallm_01"), price = 100, name = "Wall Art 3" },
        {model = GetHashKey("apa_p_h_acc_artwalll_04"), price = 100, name = "Wall Art 4" },
        {model = GetHashKey("apa_p_h_acc_artwalll_03"), price = 100, name = "Wall Art 5" },
        {model = GetHashKey("apa_mp_h_acc_rugwooll_03"), price = 100, name = "Rug 1" },
        {model = GetHashKey("apa_mp_h_acc_rugwoolm_04"), price = 100, name = "Rug 2" },
        {model = GetHashKey("apa_mp_h_acc_rugwools_03"), price = 100, name = "Rug 3" },
        {model = GetHashKey("hei_heist_str_sideboardl_05"), price = 100, name = "Fuckeye Object"}
    },

    general_2 = {
        {model = GetHashKey("prop_a4_pile_01"), price = 100, name = "A4 Pile" },
        {model = GetHashKey("prop_amb_40oz_03"), price = 100, name = "40 oz" },
        {model = GetHashKey("prop_amb_beer_bottle"), price = 100, name = "Beer" },
        {model = GetHashKey("prop_aviators_01"), price = 100, name = "Aviators" },
        {model = GetHashKey("prop_barry_table_detail"), price = 100, name = "Detail" },
        {model = GetHashKey("prop_beer_box_01"), price = 100, name = "Beers" },
        {model = GetHashKey("prop_binoc_01"), price = 100, name = "Binoculars" },
        {model = GetHashKey("prop_blox_spray"), price = 100, name = "Blox Spray" },
        {model = GetHashKey("prop_bongos_01"), price = 100, name = "Bongos" },
        {model = GetHashKey("prop_bong_01"), price = 100, name = "Bong" },
        {model = GetHashKey("prop_boombox_01"), price = 100, name = "Boombox" },
        {model = GetHashKey("prop_bowl_crisps"), price = 100, name = "Bowl Crisps" },
        {model = GetHashKey("prop_candy_pqs"), price = 100, name = "Candy" },
        {model = GetHashKey("prop_carrier_bag_01"), price = 100, name = "Carrier bag" },
        {model = GetHashKey("prop_ceramic_jug_01"), price = 100, name = "Ceramic Jug" },
        {model = GetHashKey("prop_cigar_pack_01"), price = 100, name = "Cigar Pack 1" },
        {model = GetHashKey("prop_cigar_pack_02"), price = 100, name = "Cigar Pack 2" },
        {model = GetHashKey("prop_cs_beer_box"), price = 100, name = "Beer Box 2" },
        {model = GetHashKey("prop_cs_binder_01"), price = 100, name = "Binder" },
        {model = GetHashKey("prop_cs_bs_cup"), price = 100, name = "Cup" },
        {model = GetHashKey("prop_cs_cashenvelope"), price = 100, name = "Envelope" },
        {model = GetHashKey("prop_cs_champ_flute"), price = 100, name = "Flute" },
        {model = GetHashKey("prop_cs_duffel_01"), price = 100, name = "Duffel Bag" },
        {model = GetHashKey("prop_cs_dvd"), price = 50, name = "DVD" },
        {model = GetHashKey("prop_cs_dvd_case"), price = 50, name = "DVD Case" },
        {model = GetHashKey("prop_cs_film_reel_01"), price = 100, name = "Film Reel" },
        {model = GetHashKey("prop_cs_ilev_blind_01"), price = 100, name = "Blind" },
        {model = GetHashKey("p_ld_bs_bag_01"), price = 100, name = "Bag" },
        {model = GetHashKey("prop_cs_ironing_board"), price = 100, name = "Ironing Board" },
        {model = GetHashKey("prop_cs_katana_01"), price = 100, name = "Katana" },
        {model = GetHashKey("prop_cs_kettle_01"), price = 100, name = "Kettle" },
        {model = GetHashKey("prop_cs_lester_crate"), price = 100, name = "Crate" },
        {model = GetHashKey("prop_cs_petrol_can"), price = 100, name = "Petrol Can" },
        {model = GetHashKey("prop_cs_sack_01"), price = 100, name = "Sack" },
        {model = GetHashKey("prop_cs_script_bottle_01"), price = 100, name = "Script Bottle" },
        {model = GetHashKey("prop_cs_script_bottle"), price = 100, name = "Script Bottle 2" },
        {model = GetHashKey("prop_cs_street_binbag_01"), price = 100, name = "Bin Bag" },
        {model = GetHashKey("prop_cs_whiskey_bottle"), price = 100, name = "Whiskey Bottle" },
        {model = GetHashKey("prop_sh_bong_01"), price = 100, name = "Bong" },
        {model = GetHashKey("prop_peanut_bowl_01"), price = 100, name = "Peanuts" },
        {model = GetHashKey("prop_tumbler_01"), price = 100, name = "Tumbler" }
    },

    general_3 = {
        {model = GetHashKey("v_ret_csr_bin"), price = 100, name = "CSR Bin" },
        {model = GetHashKey("v_ret_fh_wickbskt"), price = 100, name = "Basket" },
        {model = GetHashKey("v_ret_gc_bag01"), price = 100, name = "GC Bag 1" },
        {model = GetHashKey("v_ret_gc_bag02"), price = 100, name = "GC Bag 2" },
        {model = GetHashKey("v_ret_gc_bin"), price = 100, name = "GC Bin" },
        {model = GetHashKey("v_ret_gc_cashreg"), price = 100, name = "Cash Register" },
        {model = GetHashKey("v_ret_gc_chair01"), price = 100, name = "GC Chair 01" },
        {model = GetHashKey("v_ret_gc_chair02"), price = 100, name = "GC Chair 02" },
        {model = GetHashKey("v_ret_gc_clock"), price = 100, name = "Clock" },
        {model = GetHashKey("v_ret_hd_prod1_"), price = 100, name = "Prod 1" },
        {model = GetHashKey("v_ret_hd_prod2_"), price = 100, name = "Prod 2" },
        {model = GetHashKey("v_ret_hd_prod3_"), price = 100, name = "Prod 3" },
        {model = GetHashKey("v_ret_hd_prod4_"), price = 100, name = "Prod 4" },
        {model = GetHashKey("v_ret_hd_prod5_"), price = 100, name = "Prod 5" },
        {model = GetHashKey("v_ret_hd_prod6_"), price = 100, name = "Prod 6" },
        {model = GetHashKey("v_ret_hd_unit1_"), price = 100, name = "HD Unit 1" },
        {model = GetHashKey("v_ret_hd_unit2_"), price = 100, name = "HD Unit 2" },
        {model = GetHashKey("v_ret_ml_fridge02"), price = 100, name = "Fridge" },
        {model = GetHashKey("v_ret_ps_bag_01"), price = 100, name = "Bag 1" },
        {model = GetHashKey("v_ret_ps_bag_02"), price = 100, name = "Bag 2" },
        {model = GetHashKey("v_ret_ta_book1"), price = 100, name = "Book 1" },
        {model = GetHashKey("v_ret_ta_book2"), price = 100, name = "Book 2" },
        {model = GetHashKey("v_ret_ta_book3"), price = 100, name = "Book 3" },
        {model = GetHashKey("v_ret_ta_book4"), price = 100, name = "Book 4" },
        {model = GetHashKey("v_ret_ta_camera"), price = 100, name = "Cam" },
        {model = GetHashKey("v_ret_ta_firstaid"), price = 100, name = "First Aid" },
        {model = GetHashKey("v_ret_ta_hero"), price = 100, name = "Hero" },
        {model = GetHashKey("v_ret_ta_mag1"), price = 100, name = "Mag 1" },
        {model = GetHashKey("v_ret_ta_mag2"), price = 100, name = "Mag 2" },
        {model = GetHashKey("v_ret_ta_skull"), price = 100, name = "Skull" },
        {model = GetHashKey("prop_acc_guitar_01"), price = 100, name = "Guitar" },
        {model = GetHashKey("prop_amb_handbag_01"), price = 100, name = "Handbag" },
        {model = GetHashKey("prop_attache_case_01"), price = 100, name = "Case" },
        {model = GetHashKey("prop_big_bag_01"), price = 100, name = "Big Bag" },
        {model = GetHashKey("prop_bonesaw"), price = 100, name = "Bonesaw" },
        {model = GetHashKey("prop_cs_fertilizer"), price = 100, name = "Fertilizer" },
        {model = GetHashKey("prop_cs_shopping_bag"), price = 100, name = "Shopping Bag" },
        {model = GetHashKey("prop_cs_vial_01"), price = 100, name = "Vial" },
        {model = GetHashKey("prop_defilied_ragdoll_01"), price = 100, name = "Ragdoll" }
    },

    general_4 = {
        {model = GetHashKey("prop_dummy_01"), price = 100, name = "Dummy" },
        {model = GetHashKey("prop_egg_clock_01"), price = 100, name = "Egg Clock" },
        {model = GetHashKey("prop_el_guitar_01"), price = 100, name = "E Guitar 1" },
        {model = GetHashKey("prop_el_guitar_02"), price = 100, name = "E Guitar 2" },
        {model = GetHashKey("prop_el_guitar_03"), price = 100, name = "E Guitar 2" },
        {model = GetHashKey("prop_feed_sack_01"), price = 100, name = "Feed Sack" },
        {model = GetHashKey("prop_floor_duster_01"), price = 100, name = "Floor Duster" },
        {model = GetHashKey("prop_fruit_basket"), price = 100, name = "Fruit Basket" },
        {model = GetHashKey("prop_f_duster_02"), price = 100, name = "Duster" },
        {model = GetHashKey("prop_grapes_02"), price = 100, name = "Grapes" },
        {model = GetHashKey("prop_hotel_clock_01"), price = 100, name = "Hotel Clock" },
        {model = GetHashKey("prop_idol_case_01"), price = 100, name = "Idol Case" },
        {model = GetHashKey("prop_jewel_02a"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_02b"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_02c"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_03a"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_03b"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_04a"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_jewel_04b"), price = 100, name = "Jewels" },
        {model = GetHashKey("prop_j_disptray_01"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_01b"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_02"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_03"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_04"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_04b"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_05"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_j_disptray_05b"), price = 100, name = "Display Tray" },
        {model = GetHashKey("prop_ld_greenscreen_01"), price = 100, name = "Green Screen" },
        {model = GetHashKey("prop_ld_handbag"), price = 100, name = "Handbag" },
        {model = GetHashKey("prop_ld_jerrycan_01"), price = 100, name = "Jerry Can" },
        {model = GetHashKey("prop_ld_keypad_01"), price = 100, name = "Keypad 1" },
        {model = GetHashKey("prop_ld_keypad_01b"), price = 100, name = "Keypad 2" },
        {model = GetHashKey("prop_ld_suitcase_01"), price = 100, name = "Suitcase 1" },
        {model = GetHashKey("prop_ld_suitcase_02"), price = 100, name = "Suitcase 2" },
        {model = GetHashKey("hei_p_attache_case_shut"), price = 100, name = "Suitcase 3"},
        {model = GetHashKey("prop_mr_rasberryclean"), price = 100, name = "Rasberry Clean" },
        {model = GetHashKey("prop_paper_bag_01"), price = 100, name = "Paper Bag" },
        {model = GetHashKey("prop_shopping_bags01"), price = 100, name = "Shopping Bags" },
        {model = GetHashKey("prop_shopping_bags02"), price = 100, name = "Shopping Bags 2" },
        {model = GetHashKey("prop_yoga_mat_01"), price = 100, name = "Yoga Mat 1" },
        {model = GetHashKey("prop_yoga_mat_02"), price = 100, name = "Yoga Mat 2" },
        {model = GetHashKey("prop_yoga_mat_03"), price = 100, name = "Yoga Mat 3" },
        {model = GetHashKey("p_ld_sax"), price = 100, name = "Sax" },
        {model = GetHashKey("p_ld_soc_ball_01"), price = 100, name = "SOCCER Ball" },
        {model = GetHashKey("p_watch_01"), price = 100, name = "Watch 1" },
        {model = GetHashKey("p_watch_02"), price = 100, name = "Watch 2" },
        {model = GetHashKey("p_watch_03"), price = 100, name = "Watch 3" },
        {model = GetHashKey("p_watch_04"), price = 100, name = "Watch 4" },
        {model = GetHashKey("p_watch_05"), price = 100, name = "Watch 5" },
        {model = GetHashKey("p_watch_06"), price = 100, name = "Watch 6" }
    },

    small = {
        {model = GetHashKey("v_res_r_figcat"), price = 100, name = "Fig Cat" },
        {model = GetHashKey("v_res_r_figclown"), price = 100, name = "Fig Clown" },
        {model = GetHashKey("v_res_r_figauth2"), price = 100, name = "Fig Auth" },
        {model = GetHashKey("v_res_r_figfemale"), price = 100, name = "Fig Female" },
        {model = GetHashKey("v_res_r_figflamenco"), price = 100, name = "Fig Flamenco" },
        {model = GetHashKey("v_res_r_figgirl"), price = 100, name = "Fig Girl" },
        {model = GetHashKey("v_res_r_figgirlclown"), price = 100, name = "Fig Girl Clown" },
        {model = GetHashKey("v_res_r_figoblisk"), price = 100, name = "Fig Oblisk" },
        {model = GetHashKey("v_res_r_figpillar"), price = 100, name = "Fig Pillar" },
        {model = GetHashKey("v_res_r_teapot"), price = 100, name = "Teapot" },
        {model = GetHashKey("v_res_sculpt_dec"), price = 100, name = "Sculpture 1" },
        {model = GetHashKey("v_res_sculpt_decd"), price = 100, name = "Sculpture 2" },
        {model = GetHashKey("v_res_sculpt_dece"), price = 100, name = "Sculpture 3" },
        {model = GetHashKey("v_res_sculpt_decf"), price = 100, name = "Sculpture 4" },
        {model = GetHashKey("v_res_skateboard"), price = 100, name = "Skateboard" },
        {model = GetHashKey("v_res_sketchpad"), price = 100, name = "Sketchpad" },
        {model = GetHashKey("v_res_tissues"), price = 100, name = "Tissues" },
        {model = GetHashKey("v_res_tre_basketmess"), price = 100, name = "Basket" },
        {model = GetHashKey("v_res_tre_bin"), price = 100, name = "Bin" },
        {model = GetHashKey("v_res_tre_cushiona"), price = 100, name = "Cushion 1" },
        {model = GetHashKey("v_res_tre_cushionb"), price = 100, name = "Cushion 2" },
        {model = GetHashKey("v_res_tre_cushionc"), price = 100, name = "Cushion 3" },
        {model = GetHashKey("v_res_tre_cushiond"), price = 100, name = "Cushion 4" },
        {model = GetHashKey("v_res_tre_cushnscuzb"), price = 100, name = "Cushion 5" },
        {model = GetHashKey("v_res_tre_cushnscuzd"), price = 100, name = "Cushion 6" },
        {model = GetHashKey("v_res_tre_fruitbowl"), price = 100, name = "Fruitbowl" },
        {model = GetHashKey("v_med_p_sideboard"), price = 100, name = "Sideboard" },
        {model = GetHashKey("prop_idol_01"), price = 100, name = "Idol 1" },
        {model = GetHashKey("p_cs_cuffs_02_s"), price = 100, name = "Cuffs" },
        {model = GetHashKey("prop_cs_dildo_01"), price = 100, name = "Good vibes" },
        {model = GetHashKey("v_res_d_dildo_a"), price = 100, name = "Good vibes 2" },
        {model = GetHashKey("v_res_d_dildo_b"), price = 100, name = "Good vibes 3" },
        {model = GetHashKey("v_res_d_dildo_c"), price = 100, name = "Good vibes 4" },
        {model = GetHashKey("v_res_d_lube"), price = 100, name = "Lube" },
        {model = GetHashKey("v_ret_gc_trays"), price = 100, name = "Desk tray" },
        {model = GetHashKey("v_res_filebox01"), price = 100, name = "File box" }
    },

    storage = {
        {model = GetHashKey("v_res_cabinet"), price = 450, name = "Cabinet Large" },
        {model = GetHashKey("v_res_d_dressingtable"), price = 450, name = "Dressing Table" },
        {model = GetHashKey("v_res_d_sideunit"), price = 450, name = "Side Unit" },
        {model = GetHashKey("v_res_fh_sidebrddine"), price = 450, name = "Side Unit" },
        {model = GetHashKey("v_res_fh_sidebrdlngb"), price = 450, name = "Side Unit" },
        {model = GetHashKey("v_res_mbbedtable"), price = 450, name = "Bed Unit" },
        {model = GetHashKey("v_res_j_tvstand"), price = 450, name = "Tv Unit" },
        {model = GetHashKey("v_res_mbdresser"), price = 450, name = "Dresser Unit" },
        {model = GetHashKey("v_res_mbottoman"), price = 450, name = "Bottoman Unit" },
        {model = GetHashKey("v_res_mconsolemod"), price = 450, name = "Console Unit" },
        {model = GetHashKey("v_res_mcupboard"), price = 450, name = "Cupboard Unit" },
        {model = GetHashKey("v_res_mdchest"), price = 450, name = "Chest Unit" },
        {model = GetHashKey("v_res_msoncabinet"), price = 450, name = "Mason Unit" },
        {model = GetHashKey("v_res_m_armoire"), price = 450, name = "Armoire Unit" },
        {model = GetHashKey("v_res_m_sidetable"), price = 450, name = "Side Unit" },
        {model = GetHashKey("v_res_son_desk"), price = 450, name = "Desk Unit" },
        {model = GetHashKey("v_res_tre_bedsidetable"), price = 450, name = "Side Unit" },
        {model = GetHashKey("v_res_tre_bedsidetableb"), price = 450, name = "Side Unit 2" },
        {model = GetHashKey("v_res_tre_smallbookshelf"), price = 450, name = "Book Unit" },
        {model = GetHashKey("v_res_tre_storagebox"), price = 450, name = "Box Unit" },
        {model = GetHashKey("v_res_tre_storageunit"), price = 450, name = "Storage Unit" },
        {model = GetHashKey("v_res_tre_wardrobe"), price = 450, name = "Wardrobe Unit" },
        {model = GetHashKey("v_res_tre_wdunitscuz"), price = 450, name = "Wood Unit" },
        {model = GetHashKey("prop_devin_box_closed"), price = 100, name = "Bean Bag 1" },
        {model = GetHashKey("prop_mil_crate_01"), price = 100, name = "Mil Crate 1" },
        {model = GetHashKey("prop_mil_crate_02"), price = 100, name = "Mil Crate 2" },
        {model = GetHashKey("prop_ld_int_safe_01"), price = 1100, name = "Safe" }
    },

    electronics = {
        {model = GetHashKey("prop_trailr_fridge"), price = 100, name = "Old Fridge" },
        {model = GetHashKey("v_res_fh_speaker"), price = 100, name = "Speaker" },
        {model = GetHashKey("v_res_fh_speakerdock"), price = 100, name = "Speaker Dock" },
        {model = GetHashKey("v_res_fh_bedsideclock"), price = 100, name = "Bedside Clock" },
        {model = GetHashKey("v_res_fa_phone"), price = 100, name = "Phone" },
        {model = GetHashKey("v_res_fh_towerfan"), price = 100, name = "Tower Fan" },
        {model = GetHashKey("v_res_fa_fan"), price = 100, name = "Fan" },
        {model = GetHashKey("v_res_lest_bigscreen"), price = 100, name = "Bigscreen" },
        {model = GetHashKey("v_res_lest_monitor"), price = 100, name = "Monitor" },
        {model = GetHashKey("v_res_tre_mixer"), price = 100, name = "Mixer" },
        {model = GetHashKey("prop_cs_cctv"), price = 100, name = "CCTV" },
        {model = GetHashKey("prop_ld_lap_top"), price = 100, name = "Laptop" },
        {model = GetHashKey("prop_ld_monitor_01"), price = 100, name = "Monitor" },
        {model = GetHashKey("xm_prop_x17_tv_flat_02"), price = 500, name = "Flatscreen TV" },
        {model = GetHashKey("apa_mp_h_str_avunitm_03"), price = 1000, name = "TV set 1" },
        {model = GetHashKey("apa_mp_h_str_avunits_01"), price = 1000, name = "TV set 2" },
        {model = GetHashKey("apa_mp_h_str_avunits_04"), price = 1000, name = "TV set 3" },
        {model = GetHashKey("bkr_prop_clubhouse_jukebox_02a"), price = 1000, name = "Jukebox" },
        {model = GetHashKey("bkr_prop_weed_fan_floor_01a"), price = 100, name = "Floor fan" },
        {model = GetHashKey("prop_cs_keyboard_01"), price = 100, name = "Computer Keyboard" },
        {model = GetHashKey("ex_mp_h_acc_coffeemachine_01"), price = 500, name = "Coffeemachine" }
    },

    lighting = {
        {model = GetHashKey("v_corp_cd_desklamp"), price = 100, name = "Desk Corp Lamp" },
        {model = GetHashKey("v_res_desklamp"), price = 100, name = "Desk Lamp" },
        {model = GetHashKey("v_res_d_lampa"), price = 100, name = "Lamp AA" },
        {model = GetHashKey("v_res_fa_lamp1on"), price = 100, name = "Lamp 1" },
        {model = GetHashKey("v_res_fh_floorlamp"), price = 100, name = "Floor Lamp" },
        {model = GetHashKey("v_res_fh_lampa_on"), price = 100, name = "Lamp 2" },
        {model = GetHashKey("v_res_j_tablelamp1"), price = 100, name = "Table Lamp" },
        {model = GetHashKey("v_res_j_tablelamp2"), price = 100, name = "Table Lamp 2" },
        {model = GetHashKey("v_res_mdbedlamp"), price = 100, name = "Bed Lamp" },
        {model = GetHashKey("v_res_mplanttongue"), price = 100, name = "Plant Tongue Lamp" },
        {model = GetHashKey("v_res_mtblelampmod"), price = 100, name = "Table Lamp 3" },
        {model = GetHashKey("v_res_m_lampstand"), price = 100, name = "Lamp Stand" },
        {model = GetHashKey("v_res_m_lampstand2"), price = 100, name = "Lamp Stand 2" },
        {model = GetHashKey("v_res_m_lamptbl"), price = 100, name = "Table Lamp 4" },
        {model = GetHashKey("v_res_tre_lightfan"), price = 100, name = "Light Fan" },
        {model = GetHashKey("v_res_tre_talllamp"), price = 100, name = "Tall Lamp" },
        {model = GetHashKey("v_ret_fh_walllighton"), price = 100, name = "Wall Light" },
        {model = GetHashKey("v_ret_gc_lamp"), price = 100, name = "GC Lamp" },
        {model = GetHashKey("prop_dummy_light"), price = 100, name = "Flickering Light" },
        {model = GetHashKey("prop_ld_cont_light_01"), price = 100, name = "Side Wall Light" },
        {model = GetHashKey("V_44_D_emis"), price = 100, name = "Test Light" }
    },

    tables = {
        {model = GetHashKey("v_res_d_coffeetable"), price = 500, name = "Coffee Table 1" },
        {model = GetHashKey("v_res_d_roundtable"), price = 500, name = "Round Table" },
        {model = GetHashKey("v_res_d_smallsidetable"), price = 500, name = "Small Side Table" },
        {model = GetHashKey("v_res_fh_coftablea"), price = 500, name = "Table A" },
        {model = GetHashKey("v_res_fh_coftableb"), price = 500, name = "Table B" },
        {model = GetHashKey("v_res_fh_coftbldisp"), price = 500, name = "Table C" },
        {model = GetHashKey("v_res_fh_diningtable"), price = 500, name = "Dining Table" },
        {model = GetHashKey("v_res_j_coffeetable"), price = 500, name = "Coffee Table 2" },
        {model = GetHashKey("v_res_j_lowtable"), price = 500, name = "Low Table" },
        {model = GetHashKey("v_res_mdbedtable"), price = 500, name = "Bed Table" },
        {model = GetHashKey("v_res_mddesk"), price = 500, name = "Desk" },
        {model = GetHashKey("v_res_msidetblemod"), price = 500, name = "Side Table" },
        {model = GetHashKey("v_res_m_console"), price = 500, name = "Console Table" },
        {model = GetHashKey("v_res_m_dinetble_replace"), price = 500, name = "Dining Table 2" },
        {model = GetHashKey("v_res_m_h_console"), price = 500, name = "Console H Table" },
        {model = GetHashKey("v_res_m_stool"), price = 500, name = "Stool?" },
        {model = GetHashKey("v_res_tre_sideboard"), price = 500, name = "Sideboard Table" },
        {model = GetHashKey("v_res_tre_table2"), price = 500, name = "Table 2" },
        {model = GetHashKey("v_res_tre_tvstand"), price = 500, name = "Tv Table" },
        {model = GetHashKey("v_res_tre_tvstand_tall"), price = 500, name = "Tv Table Tall" },
        {model = GetHashKey("v_med_p_coffeetable"), price = 500, name = "Med Coffee Table" },
        {model = GetHashKey("v_med_p_desk"), price = 500, name = "Med Desk" },
        {model = GetHashKey("prop_yacht_table_01"), price = 100, name = "Yacht Table 1" },
        {model = GetHashKey("prop_yacht_table_02"), price = 100, name = "Yacht Table 2" },
        {model = GetHashKey("prop_yacht_table_03"), price = 100, name = "Yacht Table 3" },
        {model = GetHashKey("v_ret_csr_table"), price = 100, name = "CSR Table" },
        {model = GetHashKey("hei_heist_din_table_06"), price = 100, name = "Dinner table w chairs" }
    },

    plants = {
        {model = GetHashKey("prop_fib_plant_01"), price = 150, name = "Plant Fib" },
        {model = GetHashKey("v_corp_bombplant"), price = 170, name = "Plant Bomb" },    
        {model = GetHashKey("v_res_mflowers"), price = 170, name = "Plant Flowers" }, 
        {model = GetHashKey("v_res_mvasechinese"), price = 170, name = "Plant Chinese" }, 
        {model = GetHashKey("v_res_m_bananaplant"), price = 170, name = "Plant Banana" }, 
        {model = GetHashKey("v_res_m_palmplant1"), price = 170, name = "Plant Palm" },  
        {model = GetHashKey("v_res_m_palmstairs"), price = 170, name = "Plant Palm 2" },  
        {model = GetHashKey("v_res_m_urn"), price = 170, name = "Plant Urn" },  
        {model = GetHashKey("v_res_rubberplant"), price = 170, name = "Plant Rubber" }, 
        {model = GetHashKey("v_res_tre_plant"), price = 170, name = "Plant" }, 
        {model = GetHashKey("v_res_tre_tree"), price = 170, name = "Plant Tree" }, 
        {model = GetHashKey("v_med_p_planter"), price = 170, name = "Planter" }, 
        {model = GetHashKey("v_ret_flowers"), price = 100, name = "Flowers" },
        {model = GetHashKey("v_ret_j_flowerdisp"), price = 100, name = "Flowers 1" },
        {model = GetHashKey("v_ret_j_flowerdisp_white"), price = 100, name = "Flowers 2" },
        {model = GetHashKey("apa_mp_h_acc_vase_flowers_01"), price = 100, name = "Flowers 3" },
        {model = GetHashKey("apa_mp_h_acc_vase_flowers_02"), price = 100, name = "Flowers 4" },
        {model = GetHashKey("xm_prop_x17_xmas_tree_int"), price = 500, name = "Christmas Tree" }
    },

    kitchen = {
        {model = GetHashKey("prop_washer_01"), price = 150, name = "Washer 1" },
        {model = GetHashKey("prop_washer_02"), price = 150, name = "Washer 2" },
        {model = GetHashKey("prop_washer_03"), price = 150, name = "Washer 3" },
        {model = GetHashKey("prop_washing_basket_01"), price = 150, name = "Washing Basket" },
        {model = GetHashKey("v_res_fridgemoda"), price = 150, name = "Fridge 1" },
        {model = GetHashKey("v_res_fridgemodsml"), price = 150, name = "Fridge 2" },
        {model = GetHashKey("prop_fridge_01"), price = 150, name = "Fridge 3" },
        {model = GetHashKey("prop_fridge_03"), price = 150, name = "Fridge 4" },
        {model = GetHashKey("prop_cooker_03"), price = 150, name = "Cooker" },
        {model = GetHashKey("prop_micro_01"), price = 150, name = "Microwave 1" },
        {model = GetHashKey("prop_micro_02"), price = 150, name = "Microwave 2" },
        {model = GetHashKey("prop_wok"), price = 150, name = "Wok" },
        {model = GetHashKey("v_res_cakedome"), price = 150, name = "Cake Plate" },
        {model = GetHashKey("v_res_fa_chopbrd"), price = 150, name = "Chopping Board" },
        {model = GetHashKey("v_res_mutensils"), price = 150, name = "Utensils" },
        {model = GetHashKey("v_res_pestle"), price = 150, name = "Pestle" },
        {model = GetHashKey("v_ret_ta_paproll"), price = 150, name = "PaperRoll 1" },
        {model = GetHashKey("v_ret_ta_paproll2"), price = 150, name = "PaperRoll 2" },
        {model = GetHashKey("v_ret_fh_pot01"), price = 150, name = "Pot 1" },
        {model = GetHashKey("v_ret_fh_pot02"), price = 150, name = "Pot 2" },
        {model = GetHashKey("v_ret_fh_pot05"), price = 150, name = "Pot 3" },
        {model = GetHashKey("prop_pot_03"), price = 150, name = "Pot 4" },
        {model = GetHashKey("prop_pot_04"), price = 150, name = "Pot 5" },
        {model = GetHashKey("prop_pot_05"), price = 150, name = "Pot 6" },
        {model = GetHashKey("prop_pot_06"), price = 150, name = "Pot 7" },
        {model = GetHashKey("prop_pot_rack"), price = 150, name = "Pot Rack" },
        {model = GetHashKey("prop_kitch_juicer"), price = 150, name = "Juicer" }
    },

    bathroom = {
        {model = GetHashKey("prop_ld_toilet_01"), price = 100, name = "Toilet 1" },
        {model = GetHashKey("prop_toilet_01"), price = 100, name = "Toilet 2" },
        {model = GetHashKey("prop_toilet_02"), price = 100, name = "Toilet 3" },
        {model = GetHashKey("prop_sink_02"), price = 100, name = "Sink 1" },
        {model = GetHashKey("prop_sink_04"), price = 100, name = "Sink 2" },
        {model = GetHashKey("prop_sink_05"), price = 100, name = "Sink 3" },
        {model = GetHashKey("prop_sink_06"), price = 100, name = "Sink 4" },
        {model = GetHashKey("prop_soap_disp_01"), price = 100, name = "Soap Dispenser" },
        {model = GetHashKey("prop_shower_rack_01"), price = 100, name = "Shower Rack" },
        {model = GetHashKey("prop_handdry_01"), price = 100, name = "Hand Dryer 1" },
        {model = GetHashKey("prop_handdry_02"), price = 100, name = "Hand Dryer 2" },
        {model = GetHashKey("prop_towel_rail_01"), price = 100, name = "Towel Rail 1" },
        {model = GetHashKey("prop_towel_rail_02"), price = 100, name = "Towel Rail 2" },
        {model = GetHashKey("prop_towel_01"), price = 100, name = "Towel 1" },
        {model = GetHashKey("v_res_mbtowel"), price = 100, name = "Towel 2" },
        {model = GetHashKey("v_res_mbtowelfld"), price = 100, name = "Towel 3" },
        {model = GetHashKey("v_res_mbath"), price = 100, name = "Bath" },
        {model = GetHashKey("v_res_mbsink"), price = 100, name = "Sink" }
    },

    medical = {
        {model = GetHashKey("v_med_barrel"), price = 250, name = "Barrel" },
        {model = GetHashKey("v_med_apecrate"), price = 250, name = "Ape Crate" },
        {model = GetHashKey("v_med_apecratelrg"), price = 250, name = "Ape Crate Large" },
        {model = GetHashKey("v_med_bed1"), price = 250, name = "Bed 1" },
        {model = GetHashKey("v_med_bed2"), price = 250, name = "Bed 2" },
        {model = GetHashKey("v_med_bedtable"), price = 250, name = "Bed Table" },
        {model = GetHashKey("v_med_bench1"), price = 250, name = "Bench 1" },
        {model = GetHashKey("v_med_bench2"), price = 250, name = "Bench 2" },
        {model = GetHashKey("v_med_benchcentr"), price = 250, name = "Bench Center" },
        {model = GetHashKey("v_med_benchset1"), price = 250, name = "Bench Set" },
        {model = GetHashKey("v_med_bigtable"), price = 250, name = "Big Table" },
        {model = GetHashKey("v_med_bin"), price = 150, name = "Bin" },
        {model = GetHashKey("v_med_centrifuge1"), price = 250, name = "Centrifuge" },
        {model = GetHashKey("v_med_cooler"), price = 250, name = "Cooler" },
        {model = GetHashKey("v_med_cor_ceilingmonitor"), price = 250, name = "Monitor" },
        {model = GetHashKey("v_med_cor_autopsytbl"), price = 250, name = "Autopsy Table" },
        {model = GetHashKey("v_med_cor_cembin"), price = 250, name = "Bin" },
        {model = GetHashKey("v_med_cor_cemtrolly2"), price = 250, name = "Trolley" },
        {model = GetHashKey("v_med_cor_chemical"), price = 250, name = "Chem" },
        {model = GetHashKey("v_med_cor_emblmtable"), price = 250, name = "BLM Table" },
        {model = GetHashKey("v_med_cor_fileboxa"), price = 250, name = "File Box" },
        {model = GetHashKey("v_med_cor_filingcab"), price = 250, name = "File Cab" },
        {model = GetHashKey("v_med_cor_hose"), price = 250, name = "Hose" },
        {model = GetHashKey("v_med_cor_largecupboard"), price = 250, name = "Large Cupboard" },
        {model = GetHashKey("v_med_cor_lightbox"), price = 250, name = "Lightbox" },
        {model = GetHashKey("v_med_cor_medstool"), price = 250, name = "Medstool" },
        {model = GetHashKey("v_med_cor_minifridge"), price = 250, name = "Minifridge" },
        {model = GetHashKey("v_med_cor_papertowels"), price = 250, name = "Papertowels" },
        {model = GetHashKey("v_med_cor_photocopy"), price = 250, name = "Photocopy" },
        {model = GetHashKey("v_med_cor_tvstand"), price = 250, name = "TV Stand" },
        {model = GetHashKey("v_med_cor_wallunita"), price = 250, name = "Wall Unit" },
        {model = GetHashKey("v_med_examlight"), price = 250, name = "Exam light" },
        {model = GetHashKey("v_med_gastank"), price = 250, name = "Gas Tank" },
        {model = GetHashKey("v_med_hazmatscan"), price = 250, name = "Hazmat Scan" },
        {model = GetHashKey("v_med_hospheadwall1"), price = 250, name = "Head Wall" },
        {model = GetHashKey("v_med_hospseating1"), price = 250, name = "Seating" },
        {model = GetHashKey("v_med_hosptable"), price = 250, name = "Hosp Table" },
        {model = GetHashKey("v_med_latexgloveboxblue"), price = 50, name = "Glove Box" },
        {model = GetHashKey("v_med_medwastebin"), price = 250, name = "Wastebin" },
        {model = GetHashKey("v_med_oscillator3"), price = 250, name = "Oscillator" },
        {model = GetHashKey("prop_ld_health_pack"), price = 100, name = "Health Pack" }
    },

    criminal = {
        {model = GetHashKey("prop_weed_pallet"), price = 250, name = "Weed-pallet" },
        {model = GetHashKey("bkr_prop_weed_bigbag_01a"), price = 50, name = "Weed-bigbag" },
        {model = GetHashKey("bkr_prop_weed_drying_01a"), price = 50, name = "Weed-drying" },
        {model = GetHashKey("bkr_prop_weed_table_01a"), price = 500, name = "Weed-Table" },
        {model = GetHashKey("bkr_prop_coke_block_01a"), price = 500, name = "Coke-block" },
        {model = GetHashKey("bkr_prop_coke_powder_01"), price = 100, name = "Ligne-de-poude" },
        {model = GetHashKey("bkr_prop_coke_table01a"), price = 1000, name = "Coke-Table" },
        {model = GetHashKey("prop_meth_setup_01"), price = 500, name = "Meth-Setup" },
        {model = GetHashKey("w_sg_bullpupshotgun"), price = 5000, name = "Fake-Bullpup" },
        {model = GetHashKey("w_mg_minigun"), price = 10000, name = "Fake-minigun" },
        {model = GetHashKey("bkr_prop_bkr_cashpile_07"), price = 10000, name = "Fake-cashpile" },
        {model = GetHashKey("bkr_prop_bkr_cashpile_06"), price = 10000, name = "Fake-cashpile2" },
        {model = GetHashKey("w_lr_homing"), price = 20000, name = "Fake-Rocket" },
        {model = GetHashKey("w_me_bat"), price = 200, name = "Bat" },
        {model = GetHashKey("prop_sign_road_01a"), price = 200, name = "Stop-sign voler" }
    }
}