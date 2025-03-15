                    case 2:
                        SavedDrillsView(appModel: appModel, sessionModel: sessionModel)
                    case 3:
                        ProfileView(model: model, appModel: appModel, userManager: userManager, sessionModel: sessionModel)
                    default:
                        SessionGeneratorView(model: model, appModel: appModel, sessionModel: sessionModel)
                    } 