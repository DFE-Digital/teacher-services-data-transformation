workspace "Teacher Services Identity" "Model of the Teacher Services Identity software system" {

    model {
          
            
            # users
            
            npquser = person "NPQ User" "A person in education withing to register for an NPQ"
            
            findtrnuser = person "Lost TRN User" "A person wanting to fing their Teacher Reference Number (TRN)" "Lost TRN User"
            qualifiedteacher = person "Qualified Teacher" "Newly Qualified and Fully Qualified Teachers"
            traineeteacher = person "Trainee Teacher" "Trainee Teachers"
            ittprovider = person "Initial Teacher Training Provider" "Higher education institute initial teacher training providers"
            schoolemployer = person "Emlpoyer (School)" "Nurseries, Schools, Academies, Free schools, Independent schools and Colleges"
            appropriatebody = person "Appropriate Body" "Organisations responsible for the quality assurance process for early career teacher induction"
            qtsequivelenceteacher = person "None QTS Teacher" "Qualified teacher outside of England and Wales"
            noneschoolemployer = person "Employer (None School)" "Teacher supply agencies, local authorities and training providers"
            citizen = person "Citizen" "Anybody who neeeds to use the TRA's public Gov.Uk services"
            
            # systems
            trasoftwaresystem = softwaresystem "TRA Services" "Teacher Regulation Agency sytems including DQT CRM, Qualifications API, Apply for QTS"{
                
                    qualifiedteachersapicont = container "Teacher Qualifications REST API" "qualified-teachers-api" ".Net API RESTful API for integrating with the Database of Qualified Teachers CRM" {
                    qualifiedteachersapi = component "qualified-teachers-api" "REST API providing data integration to TRA data sources" ".Net core 6.x, PostgreSQL 13.x,.Net core 6.x SDK"
                    
                    }

                    findcont = container "Find-A-Lost-Trn Gov.Uk Web Application" "https://find-a-lost-trn.education.gov.uk/start" "Ruby on Rails" {
                    # find a lost trn users
                    # qualifiedteacher -> this "https"
                    # traineeteacher -> this "https"
                    # citizen -> this "https"
                    this -> qualifiedteachersapi "uses"
                    findrubyonrailsmonolith = component "find-a-lost-trn Monolith" "Find a lost TRN is a monolithic Rails app built with the GOVUK Design System and hosted on GOVUK PaaS." "Ruby 3.x,Node.js 16.x,Yarn 1.22.x,PostgreSQL 13.x,Redis 6.x"
                    findrubyonrailsmonolith -> qualifiedteachersapi "https"
                }
                
                d365cont = container "DQT CRM" "DQT D365 SAAS Service" "SAAS"{
                    dqtcrm = component "CRM" "CRM instance providing customer relationship management and data store https://ent-dqt-prod.crm4.dynamics.com" "MS D365 SAAS"
                    
                
                }
                
            }

          



            
            # **********software system**********
            tsidentitysoftwareSystem = softwareSystem "Teacher Services Identity Software System" "A distibuted set of software containers that provide identity services and data related to teacher servcies users"{
                # containers
                
                    teacheraccountcont = container "Teacher Account And Profile" "OIDC Provider and Record Checking Service (Profile)" "Ruby Application"{
                        teacheraccoidcprov = component "OIDC Provider" "OIDC provider on top of OAUTH - identity provision" "Ruby"
                        teacheraccoidcconfigdb = component "OIDC Config" "OIDC config database - claim / token def store" "PostgreSQL" "Database"
                        teacheraccuserdatadb = component "Teacher Account User Data" "Teacher account user data" "PostgreSQL" "Database"
                        recordcheckorchestrator = component "Record Check Orchestrator" "Record checking orchestration, claim creation" "Ruby" 
                        # recordcheckinterupter = component "Interuptor" "Record check interupt, present questions (relevant to service / claim) to check identity" "Ruby" 
                        recordcheckapi = component "RCS API" "Record check API, out of band (account) API" "Ruby" "Future Phase"
                        bookendservice = component "Bookend Service" "Bookend interupt service, redirects users to UI to get input data needed to match/fulfill claim token (NPQ = QTS)"
                }
                    
                   
                
                
                }
                
                # **********software system**********
            npqsoftwareSystem = softwareSystem "NPQ Software System" "An application used to register for an NPQ"{
                # containers
                
                    npqcont = container "NPQ Application" "Gov.Uk website used to register for an NPQ" "Ruby Application"{
                        npqcomp = component "NPQ User Interface" "Register for NPQ" "Ruby"
                        
                        
                }
                    
                   
                
                
                }
            
             anyothersoftwareSystem = softwareSystem "Any Teacher Services Service" "Any authorised (by token/client registration) TS subscribing service" "Future Phase"{
                # containers
                
                    anycont = container "A Teacher Services Digital Service" "Gov.Uk website" "Ruby Application"{
                        anycomp = component "A Teacher Services Digital Service" "A.N.Other Service" "Ruby"
                        
                    }
                }
            
            # **********system context user relationships**********
            
            tsidentitysoftwareSystem -> trasoftwaresystem "Consumes QTS data from"
            npquser -> npqsoftwareSystem "Uses"
            npqsoftwareSystem -> tsidentitysoftwareSystem "Authenticates with Teacher Account and recieved Teacher Profile Data"
            findtrnuser -> trasoftwaresystem "Uses"
            recordcheckorchestrator -> qualifiedteachersapi "Gets data from appropriate source for claim token (NPQ = QTS)"
            recordcheckorchestrator -> teacheraccuserdatadb "CRUD"
            recordcheckorchestrator -> findrubyonrailsmonolith "Invokes"
            teacheraccoidcprov -> teacheraccoidcconfigdb "Matches client Id to claim e.g. QTS"
            teacheraccoidcprov -> recordcheckorchestrator "Given a client_id / claim match invoke..."
            # npqcomp -> findrubyonrailsmonolith "NPQ calls bookend service"
            recordcheckorchestrator -> bookendservice "Invokes Bookend Service for claim token"
            # recordcheckinterupter -> findrubyonrailsmonolith "Redirects to"
            
            recordcheckapi -> recordcheckorchestrator "Uses"
            anyothersoftwareSystem -> tsidentitysoftwareSystem "Uses Teacher Profile / Record Check API"
            anycomp -> recordcheckapi "Consumes Teacher Profile / Record Check"
            npqcomp -> teacheraccoidcprov "calls /auth using OIDC"
        }
   

      
    
    # **********views**********
    views {
        systemContext tsidentitysoftwareSystem "SystemContext" "Full Context" {
            include *
            autoLayout 
        }
        
        systemContext tsidentitysoftwareSystem "UserContext" "User Context" {
            include *
            autolayout
        }
        
        systemContext trasoftwaresystem "trasystemcontext" "TRA System Context" {
            include *
            autolayout
        }
        
        systemContext npqsoftwareSystem "npqsystemcontext" "TRA System Context" {
            include *
            autolayout
        }
        
        container tsidentitysoftwareSystem {
            
            include *
            autolayout 
        }
        
        container trasoftwaresystem {
            
            include *
            autolayout 
        }
        
        component teacheraccountcont {
            
            include *
            autolayout 
        }
        
        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            
            element "System User" {
                background #999999
            }
            
            element "Future Phase" {
                background #D03317
            }
            
            element "Database" {
                shape Cylinder
            }
        }
    }
    
}