// The 'aleo_financial_kyc' program.
program aleo_financial_kyc.aleo {

    struct PersonalInfo {
        reference_id: field,
        first_name: field,
        middle_name: field,
        last_name: field,
        dob_day: u32,
        dob_month: u32,
        dob_year: u32,
        nationality: field,
         national_reference_id: field,
        created_at: field,
    }

    struct ContactInfo {
        reference_id: field,
        residential_address_1: field,
        residential_address_2: field,
        residential_address_3: field,
        residential_state: field,
        residential_country: field,
        mailing_address_1: field,
        mailing_address_2: field,
        mailing_address_3: field,
        mailing_state: field,
        mailing_country: field,
        email_address: field,
        email_address_domain: field,
        backup_email_address: field,
        backup_email_address_domain: field,
        phone_country_code: u32,
        phone_area_code: u32,
        phone_number: u32,
    }

    struct EmploymentInfo {
        reference_id: field,
        occupation: field,
        employer_name_1: field,
        employer_name_2: field,
        employer_company_type: field,
        employer_address_1: field,
        employer_address_2: field,
        employer_address_3: field,
        employer_state: field,
        employer_country: field,
    }

    struct FinancialInfo {
        reference_id: field,
        annual_income_amount: u64,
        source_of_income: field,
        funds_amount: u64,
        source_of_fund: field,
        wealth_amount: u64,
        source_of_wealth: field,
        estimated_net_worth: u64,
    }

    struct InvestmentExpInfo {
        reference_id: field,
        stocks: bool,
        bonds: bool,
        mutual_funds: bool, // These are investment vehicles that pool money from many investors to purchase a diversified portfolio of stocks, bonds, or other assets.
        exchange_traded_funds: bool, // Similar to mutual funds, but they are traded on an exchange like individual stocks.
        real_estate: bool,
        commodities: bool,
        cryptocurrencies: bool,
        options_futures: bool, // Contracts that give the right, but not the obligation, to buy or sell an asset at a specific price before a certain date.
        foreign_exchange: bool,
        equity_venture_capital: bool, // Investments in companies or startups.
        hedge_funds: bool, // Pooled investment funds that use a variety of strategies to earn returns for their investors.
        certificate_of_deposit: bool, //  A type of time deposit offered by banks with a fixed term.
        money_market_funds: bool, // Mutual funds that invest in short-term, high-quality investments.
        annuities: bool, // Financial products sold by insurance companies that provide a stream of income in the future.
        risk_tolerance: u8,
        investment_goals_1: field,
        investment_goals_2: field,
        investment_goals_3: field,
        investment_goals_4: field,
        investment_goals_5: field,
    }

    struct PepInfo {
        reference_id: field,
        political_association: bool,
        association_declaration_1: field,
        association_declaration_2: field,
        association_declaration_3: field,
        association_declaration_4: field,
        association_declaration_5: field,
    }

    struct RiskAssessmentInfo {
        reference_id: field,
        country_risk: u8,
        country_reason_1: field,
        country_reason_2: field,
        employment_risk: u8,
        employment_reason_1: field,
        employment_reason_2: field,
        account_activity_risk: u8,
        account_activity_amount: u64,
        account_activity_frequency: field,
        account_activity_reason_1: field,
        account_activity_reason_2: field,
    }

    // create two copies of the KYC one for customer one for instituition ?
    record FinancialKyc {
        private owner: address,
        private secondary_owner: address,
        private risk_assessment_info: RiskAssessmentInfo,
        private pep_info: PepInfo,
        private investment_exp_info: InvestmentExpInfo,
        private financial_info: FinancialInfo,
        private employment_info: EmploymentInfo,
        private contact_info: ContactInfo,
        private personal_info: PersonalInfo,
        private created_at: field,
    }

    record FinancialInstitution {
        private owner: address,
        private is_trusted: bool,
        id: field,
        private company_name_1: field,
        private company_name_2: field,
        private company_type: field,
        private company_address_1: field,
        private company_address_2: field,
        private company_address_3: field,
        private company_state: field,
        private company_country: field,
        private email_address: field,
        private email_address_domain: field,
        private backup_email_address: field,
        private backup_email_address_domain: field,
        private phone_country_code: u32,
        private phone_area_code: u32,
        private phone_number: u32,
        created_at: field,
    }

    // financial_instituitions maps financial institution's id to an address
    mapping financial_instituitions: field => address;

    // trusted_financial_instituitions maps financial institution's address to a boolean to represent it being a dao approved financial institution
    mapping trusted_financial_instituitions: address => bool;

    transition create_fi(fi: FinancialInstitution) -> FinancialInstitution {
        let new_fi: FinancialInstitution = FinancialInstitution {
            owner: self.caller,
            is_trusted: false,
            id: fi.id,
            company_name_1: fi.company_name_1,
            company_name_2: fi.company_name_2,
            company_type: fi.company_type,
            company_address_1: fi.company_address_1,
            company_address_2: fi.company_address_2,
            company_address_3: fi.company_address_3,
            company_state: fi.company_state,
            company_country: fi.company_country,
            email_address: fi.email_address,
            email_address_domain: fi.email_address_domain,
            backup_email_address: fi.backup_email_address,
            backup_email_address_domain: fi.backup_email_address_domain,
            phone_country_code: fi.phone_country_code,
            phone_area_code: fi.phone_area_code,
            phone_number: fi.phone_number,
            created_at: fi.created_at,
        };

        return new_fi then finalize(self.caller, fi.id);
    }

    finalize create_fi(owner: address, fi_id: field) {
        assert(Mapping::get(financial_instituitions, fi_id) != owner);

        Mapping::set(financial_instituitions, fi_id, owner);
    }

    transition approve_fi(fi: FinancialInstitution) -> FinancialInstitution {
        // check that caller belongs to the DAO
        let new_fi: FinancialInstitution = FinancialInstitution {
            owner: fi.owner,
            is_trusted: true,
            id: fi.id,
            company_name_1: fi.company_name_1,
            company_name_2: fi.company_name_2,
            company_type: fi.company_type,
            company_address_1: fi.company_address_1,
            company_address_2: fi.company_address_2,
            company_address_3: fi.company_address_3,
            company_state: fi.company_state,
            company_country: fi.company_country,
            email_address: fi.email_address,
            email_address_domain: fi.email_address_domain,
            backup_email_address: fi.backup_email_address,
            backup_email_address_domain: fi.backup_email_address_domain,
            phone_country_code: fi.phone_country_code,
            phone_area_code: fi.phone_area_code,
            phone_number: fi.phone_number,
            created_at: fi.created_at,
        };

        return new_fi then finalize(self.caller, fi.owner, fi.id);
    }

    finalize approve_fi(daoMember: address, fi_owner: address, fi_id: field) {
        // checks that it is the DAO member
        assert(daoMember == aleo147pn9l4pmd5q6wfqk67werwdm5wa9y04ufk3kmyzmt2mcjpxqsrse9euhf);
        // checks that the FI exists
        assert(Mapping::get(financial_instituitions, fi_id) == fi_owner);

        Mapping::set(trusted_financial_instituitions, fi_owner, true);
    }


    transition fi_create_kyc(kyc: FinancialKyc, caller: address) -> (FinancialKyc, FinancialKyc) {
        // fi owned kyc document
        let new_fi_kyc: FinancialKyc = FinancialKyc {
            owner: caller,
            secondary_owner: kyc.secondary_owner,
            risk_assessment_info: kyc.risk_assessment_info,
            pep_info: kyc.pep_info,
            investment_exp_info: kyc.investment_exp_info,
            financial_info: kyc.financial_info,
            employment_info: kyc.employment_info,
            contact_info: kyc.contact_info,
            personal_info: kyc.personal_info,
            created_at: kyc.created_at
        };
        // customer owned kyc
        let new_customer_kyc: FinancialKyc = FinancialKyc {
            owner: kyc.secondary_owner,
            secondary_owner: caller,
            risk_assessment_info: kyc.risk_assessment_info,
            pep_info: kyc.pep_info,
            investment_exp_info: kyc.investment_exp_info,
            financial_info: kyc.financial_info,
            employment_info: kyc.employment_info,
            contact_info: kyc.contact_info,
            personal_info: kyc.personal_info,
            created_at: kyc.created_at,
        };

        return (new_fi_kyc, new_customer_kyc) then finalize(self.caller);
    }

    finalize fi_create_kyc(fi_address: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_address));
    }

    // Because there's no concept of an array. what we will have is a complete duplicate of the data
    transition post_share_kyc(kyc: FinancialKyc, fi_shared_to: address) -> FinancialKyc {
        // fi owned kyc document
        let new_fi_kyc: FinancialKyc = FinancialKyc {
            owner: fi_shared_to,
            secondary_owner: self.caller,
            risk_assessment_info: kyc.risk_assessment_info,
            pep_info: kyc.pep_info,
            investment_exp_info: kyc.investment_exp_info,
            financial_info: kyc.financial_info,
            employment_info: kyc.employment_info,
            contact_info: kyc.contact_info,
            personal_info: kyc.personal_info,
            created_at: kyc.created_at,
        };

        return new_fi_kyc then finalize(fi_shared_to);
    }

    finalize post_share_kyc(fi_shared_to: address) {
        assert(Mapping::get(trusted_financial_instituitions, fi_shared_to));
    }
}
