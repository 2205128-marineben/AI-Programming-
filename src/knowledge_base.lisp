;;;; knowledge_base.lisp
;;;; Knowledge base aligned with M-Float Tech Communications website content.
;;;; Live website data overrides static fallbacks via site_context.lisp.

(in-package :cl-user)

(load (merge-pathnames "site_context.lisp" *load-pathname*))
(load (merge-pathnames "ticket_context.lisp" *load-pathname*))
(load (merge-pathnames "conversation_context.lisp" *load-pathname*))
(load (merge-pathnames "greeting.lisp" *load-pathname*))

(defparameter *intent-patterns*
  '((GREETING
     ("hello" "hi" "hey" "good morning" "good afternoon" "good evening"
      "greetings" "howdy"))

    (EXIT
     ("goodbye" "bye" "exit" "quit" "see you" "farewell" "stop" "end chat"))

    (HELP
     ("help" "what can you do" "options" "menu" "assist me" "support options"))

    (THANK_YOU
     ("thank you" "thanks" "appreciate" "grateful" "thank"))

    (AFFIRMATIVE
     ("yes" "yeah" "yep" "sure" "ok" "okay" "please" "go ahead" "alright"))

    (COMPANY_INFO
     ("what is mfloat" "what is m float" "about mfloat" "about company"
      "about the company" "tell me about this site" "tell me about the site"
      "tell me about this website" "tell me about the website"
      "tell me about mfloat" "tell me about the company"
      "company information" "who we are" "this website"
      "about this website" "about the website" "about this site"
      "what is this website" "what is this site" "about the site"))

    (COMPANY_LOCATION
     ("where are you located" "where are your offices" "where is your office"
      "where are your office" "offices located" "office located"
      "company location" "office location" "office address" "your address"
      "where is mfloat" "physical location" "find office" "your offices"
      "where do you operate" "based where" "located where"))

    (CONTACT_INFO
     ("contact" "phone number" "email address" "reach support"
      "customer care number" "call center" "hotline" "contact support"
      "how to reach" "get in touch" "whatsapp" "company email" "your email"
      "contact person" "contact details" "contact info" "email"
      "phone" "call you" "mobile number" "who can i contact"))

    (CAREERS
     ("careers" "career" "carreers" "job openings" "job vacancies"
      "jobs available" "vacancies" "hiring" "internship" "internships"
      "work for you" "join your team" "open positions" "any careers"
      "careers available" "carreers available"))

    (SERVICES_OVERVIEW
     ("what services" "your services" "what do you offer" "services you provide"
      "list services" "what can you build" "what do you do"))

    (SOFTWARE_DEVELOPMENT
     ("software development" "custom software" "build software" "develop app"
      "web application" "mobile application" "business management system"
      "payment integration" "analytics dashboard"))

    (SYSTEM_MAINTENANCE
     ("system maintenance" "maintenance support" "ongoing maintenance"
      "bug fixes" "system monitoring" "patch management" "backup recovery"))

    (SYSTEM_INTEGRATION
     ("system integration" "integrate systems" "api integration"
      "payment gateway" "sms api" "banking integration" "third party api"
      "connect platforms"))

    (WEB_DIGITAL
     ("website development" "web development" "digital solutions"
      "corporate website" "ecommerce" "e-commerce" "client portal"
      "booking system" "online platform"))

    (ICT_CONSULTANCY
     ("ict consultancy" "technology consultancy" "it consultancy"
      "digital transformation" "technology planning" "system architecture"
      "it strategy" "operational automation"))

    (WHY_CHOOSE_US
     ("why choose you" "why mfloat" "why choose mfloat" "what makes you different"
      "your advantages" "why should i choose"))

    (DEVELOPMENT_PROCESS
     ("development process" "how do you work" "your process" "project process"
      "how do you build" "workflow" "methodology"))

    (INDUSTRIES
     ("industries" "which industries" "sectors" "who do you serve"
      "telecommunications" "financial services" "retail" "smes"))

    (VISION_MISSION
     ("vision" "mission" "vision and mission" "company vision" "company mission"))

    (GET_QUOTE
     ("get a quote" "request quote" "pricing" "how much" "project cost"
      "start a project" "hire you" "work with you"))

    (PORTFOLIO
     ("portfolio" "past projects" "previous work" "case studies" "our work"))

    (TECHNICAL_SUPPORT
     ("technical support" "technical issue" "system error" "app not working"
      "software problem" "portal down" "need support" "troubleshoot"))

    (COMPLAINTS
     ("complaint" "file complaint" "raise complaint" "unhappy" "dissatisfied"
      "bad service" "report issue" "lodge complaint"))

    (REQUEST_AGENT
     ("speak to agent" "talk to agent" "human agent" "live agent" "real person"
      "contact agent" "available agent" "connect me to agent" "transfer to agent"
      "speak to someone" "talk to someone"))

    (CREATE_TICKET
     ("create ticket" "open ticket" "submit ticket" "raise ticket" "new ticket"
      "file a ticket" "support ticket" "start review" "start the review"
      "unsuspension review"))

    (CHECK_TICKET_STATUS
     ("check status" "ticket status" "status of my request" "my request status"
      "check my ticket" "where is my ticket"))

    (TICKET_UPDATES
     ("any updates" "any update" "updates" "update on my ticket" "news on my ticket"
      "progress on my request" "what is happening" "what's happening"))

    (ESCALATE_TICKET
     ("escalate" "escalate this" "escalate issue" "escalate ticket" "urgent"
      "highest priority" "escalate please"))

    (FRUSTRATED
     ("frustrating" "this is frustrating" "very frustrating" "not happy"
      "this is ridiculous" "unacceptable"))

    (SECURITY
     ("security" "data protection" "secure systems" "protect data"
      "system security" "safe integration"))))

(defparameter *intent-responses*
  '((GREETING
     "Hello, How can I assist you today?")

    (EXIT
     "Thank you for contacting MFloat Tech Communications. Have a great day! Goodbye.")

    (HELP
     "I can help with company information, services, contact details, our development process, industries we serve, and technical support. Just ask in plain language.")

    (THANK_YOU
     "You are welcome! Is there anything else I can help you with?")

    (AFFIRMATIVE
     "Great! I can help with our services, software development, system integration, web solutions, contact details, or starting a project. What would you like to know?")

    (COMPANY_INFO
     "MFloat Tech Communications is a modern technology company focused on building reliable, scalable, and intelligent digital solutions for businesses, organizations, and growing enterprises.")

    (COMPANY_LOCATION
     "MFloat Tech Communications is based in Kenya. Use the Contact section on our website for the latest address and reach-out options.")

    (CONTACT_INFO
     "You can reach MFloat Tech Communications via the Contact section on our website for phone, WhatsApp, email, and address details.")

    (CAREERS
     "We do not currently list open roles on the website. If you are interested in joining MFloat Tech Communications, email us through the Contact section with your CV and area of interest.")

    (SERVICES_OVERVIEW
     "MFloat Tech Communications offers Custom Software Development, System Maintenance & Technical Support, System Integration Services, Web & Digital Solutions, and ICT Consultancy.")

    (SOFTWARE_DEVELOPMENT
     "We develop tailored software systems including business management systems, financial and transaction systems, web and mobile applications, payment integration systems, and reporting and analytics dashboards.")

    (SYSTEM_MAINTENANCE
     "We provide ongoing maintenance and support: bug fixes, system monitoring, security updates, performance optimization, backup and recovery support, and continuous system improvements.")

    (SYSTEM_INTEGRATION
     "We integrate payment gateways, SMS and communication APIs, banking and transaction systems, third-party APIs, cloud services, and internal enterprise systems.")

    (WEB_DIGITAL
     "We design and develop corporate websites, client portals, e-commerce platforms, booking and reservation systems, and digital communication platforms.")

    (ICT_CONSULTANCY
     "We provide guidance on technology planning, digital transformation, system architecture, operational automation, and IT strategy.")

    (WHY_CHOOSE_US
     "Clients choose MFloat for experienced technical expertise, reliable support, scalable systems, security-focused development, and client-focused delivery.")

    (DEVELOPMENT_PROCESS
     "Our process: 1) Requirement Analysis 2) Solution Design 3) Development & Integration 4) Testing & Deployment 5) Support & Maintenance.")

    (INDUSTRIES
     "We serve telecommunications, financial services, agribusiness, retail and e-commerce, logistics and transport, hospitality, SMEs, enterprises, and service-based businesses.")

    (VISION_MISSION
     "Our mission is to build reliable, scalable, and intelligent digital solutions. Our vision is to empower businesses through modern technology and dependable support.")

    (GET_QUOTE
     "To discuss a project or request a quote, contact us through the Contact section on our website with your requirements and timeline.")

    (PORTFOLIO
     "Explore our Portfolio section on the website to see examples of systems, integrations, and digital solutions we have delivered.")

    (TECHNICAL_SUPPORT
     "For technical support, contact us via phone, WhatsApp, or email listed on our website. Share your system details and issue description so our team can assist quickly.")

    (COMPLAINTS
     "To file a complaint, I can open a support ticket for you or you can contact us through the details on our website.")

    (REQUEST_AGENT
     "I can connect you with a support agent. Please describe your issue and I will open a support ticket for you.")

    (CREATE_TICKET
     "Share a short description of your issue and I will open a support ticket for you.")

    (CHECK_TICKET_STATUS
     "Tell me your ticket number or ask me to check the status of your latest request.")

    (TICKET_UPDATES
     "I can check whether there are any new updates on your support ticket.")

    (ESCALATE_TICKET
     "I can escalate your support ticket with an urgent follow up to the team.")

    (FRUSTRATED
     "I understand this is frustrating. I will follow up on your support request and ask for clear next steps.")

    (SECURITY
     "We prioritize data protection, secure integrations, and system reliability across all software, integration, and digital solutions we deliver.")

    (UNKNOWN
     "I'm sorry, I don't have information about that yet. Please contact MFloat Tech Communications using the contact details on our website, or try asking about our services, company, or support.")))

(defun get-all-intents ()
  (mapcar #'car *intent-patterns*))

(defun get-patterns-for-intent (intent)
  (cadr (assoc intent *intent-patterns*)))

(defun site-aware-response (intent)
  "Build a response from live website content when available."
  (case intent
    (GREETING
     (contextual-greeting-response))
    (COMPANY_INFO
     (let ((desc (site-field :about-description))
           (heading (site-field :about-heading))
           (highlights (site-field :about-highlights)))
       (when desc
         (if highlights
             (format nil "~a~%~a~%Our focus areas include: ~a." (or heading "About MFloat") desc highlights)
             (format nil "~a~%~a" (or heading "About MFloat") desc)))))
    (COMPANY_LOCATION
     (let ((address (site-field :contact-address)))
       (when address
         (format nil "Our offices are located in ~a. For more details, use the Contact section on our website." address))))
    (CONTACT_INFO
     (let ((phone (site-field :contact-phone))
           (whatsapp (site-field :contact-whatsapp))
           (email (site-field :contact-email))
           (address (site-field :contact-address)))
       (when (or phone email whatsapp address)
         (format nil "Contact MFloat Tech Communications — Phone: ~a | WhatsApp: ~a | Email: ~a | Location: ~a"
                 (or phone "See website")
                 (or whatsapp "See website")
                 (or email "See website")
                 (or address "See website")))))
    (CAREERS
     (let ((email (site-field :contact-email)))
       (format nil "We do not currently publish open vacancies on this website. To enquire about careers or internships, email ~a with your CV and area of interest."
               (or email "mfloat.team@gmail.com"))))
    (SERVICES_OVERVIEW
     (let ((summary (site-field :services-summary)))
       (when summary
         (format nil "MFloat Tech Communications offers the following services: ~a" summary))))
    (SOFTWARE_DEVELOPMENT
     (when (site-field :services-summary)
       (format nil "Custom Software Development: ~a"
               (extract-service-text "Custom Software Development"))))
    (SYSTEM_MAINTENANCE
     (when (site-field :services-summary)
       (format nil "System Maintenance & Technical Support: ~a"
               (extract-service-text "System Maintenance"))))
    (SYSTEM_INTEGRATION
     (when (site-field :services-summary)
       (format nil "System Integration Services: ~a"
               (extract-service-text "System Integration"))))
    (WEB_DIGITAL
     (when (site-field :services-summary)
       (format nil "Web & Digital Solutions: ~a"
               (extract-service-text "Web & Digital"))))
    (ICT_CONSULTANCY
     (when (site-field :services-summary)
       (format nil "ICT Consultancy: ~a"
               (extract-service-text "ICT Consultancy"))))
    (GET_QUOTE
     (let ((email (site-field :contact-email))
           (phone (site-field :contact-phone)))
       (when (or email phone)
         (format nil "To request a quote or start a project, contact us at ~a~@[ or call ~a~]. Share your requirements and timeline."
                 (or email "our website contact form")
                 phone))))
    (TECHNICAL_SUPPORT
     (let ((email (site-field :contact-email))
           (phone (site-field :contact-phone)))
       (when (or email phone)
         (format nil "For technical support, reach us at ~a~@[ or ~a~]. Describe your system and issue so we can help quickly."
                 (or phone "the phone number on our website")
                 email))))
    (COMPLAINTS
     (let ((email (site-field :contact-email)))
       (when email
         (format nil "To file a complaint, email ~a with your name, service details, and issue. We will respond as soon as possible." email))))
    (t nil)))

(defun extract-service-text (service-name)
  "Extract one service entry from the website services summary."
  (let* ((summary (site-field :services-summary))
         (start (and summary (search service-name summary :test #'char-equal))))
    (if start
        (let* ((after (subseq summary start))
               (next (or (search ". 2." after)
                         (search ". 3." after)
                         (search ". 4." after)
                         (search ". 5." after)
                         (length after))))
          (string-trim '(#\space #\.) (subseq after 0 next)))
        summary)))

(defun get-response-for-intent (intent)
  (or (ticket-aware-response intent)
      (site-aware-response intent)
      (cadr (assoc intent *intent-responses*))
      (cadr (assoc 'UNKNOWN *intent-responses*))))

(defun intent-display-name (intent)
  (ecase intent
    (GREETING "Greeting")
    (EXIT "Exit")
    (HELP "Help")
    (THANK_YOU "Thank You")
    (AFFIRMATIVE "Affirmative")
    (COMPANY_INFO "Company Information")
    (COMPANY_LOCATION "Company Location")
    (CONTACT_INFO "Contact Information")
    (CAREERS "Careers")
    (SERVICES_OVERVIEW "Services Overview")
    (SOFTWARE_DEVELOPMENT "Software Development")
    (SYSTEM_MAINTENANCE "System Maintenance")
    (SYSTEM_INTEGRATION "System Integration")
    (WEB_DIGITAL "Web & Digital Solutions")
    (ICT_CONSULTANCY "ICT Consultancy")
    (WHY_CHOOSE_US "Why Choose Us")
    (DEVELOPMENT_PROCESS "Development Process")
    (INDUSTRIES "Industries Served")
    (VISION_MISSION "Vision & Mission")
    (GET_QUOTE "Request Quote")
    (PORTFOLIO "Portfolio")
    (TECHNICAL_SUPPORT "Technical Support")
    (COMPLAINTS "Complaints")
    (REQUEST_AGENT "Request Agent")
    (CREATE_TICKET "Create Ticket")
    (CHECK_TICKET_STATUS "Check Ticket Status")
    (TICKET_UPDATES "Ticket Updates")
    (ESCALATE_TICKET "Escalate Ticket")
    (FRUSTRATED "Customer Frustration")
    (SECURITY "Security")
    (UNKNOWN "Unknown")))
