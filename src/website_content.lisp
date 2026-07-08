;;;; website_content.lisp
;;;; Default website content mirrored from the M-Float React site (siteDefaults.ts).

(in-package :cl-user)

(defun load-default-website-content ()
  "Load the same default content shown on the M-Float website."
  (set-site-context
   :about-heading "Who We Are"
   :about-description "MFloat Tech Communications is a modern technology company focused on building reliable, scalable, and intelligent digital solutions for businesses, organizations, and growing enterprises. We specialize in software development, system integration, digital automation, communication technologies, and technical support services tailored to solve real business challenges."
   :about-highlights "Software Development, System Integration, Digital Automation, Communication Technologies, Technical Support"
   :contact-phone "+254 729 137 818"
   :contact-whatsapp "+254 729 137 818"
   :contact-email "mfloat.team@gmail.com"
   :contact-address "Kenya"
   :services-summary "1. Custom Software Development — We develop tailored software systems designed to match specific business operations and workflows, from business management to payment integration. Features: Business Management Systems, Financial & Transaction Systems, Web & Mobile Applications, Payment Integration Systems, Reporting & Analytics Dashboards. 2. System Maintenance & Technical Support — We provide ongoing maintenance and support services to ensure systems remain secure, updated, and fully operational at all times. Features: Bug Fixes & System Monitoring, Security Updates & Patch Management, Performance Optimization, Backup & Recovery Support, Continuous System Improvements. 3. System Integration Services — We help organizations connect different platforms and services for smooth data flow and operational efficiency across all systems. Features: Payment Gateways, SMS & Communication APIs, Banking & Transaction Systems, Third-Party & Cloud APIs, Internal Enterprise Systems. 4. Web & Digital Solutions — We design and develop modern, responsive, and secure digital platforms including corporate websites, e-commerce, and online service platforms. Features: Corporate Websites, E-Commerce Platforms, Client Portals, Booking & Reservation Systems, Digital Communication Platforms. 5. ICT Consultancy — We provide professional guidance on technology planning, digital transformation, system architecture, and operational automation. Features: Technology Planning, Digital Transformation, System Architecture, Operational Automation, IT Strategy."
   :tagline "Building Reliable, Scalable & Intelligent Digital Solutions for Businesses"))
