package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.util.Arrays;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Checks recipient accounts and source IPs against known sanctions and fraud blacklists.
 * This is a critical rule: triggering this immediately demands a CRITICAL risk score
 * and transaction rejection.
 *
 * Demonstrates Collections: Thread-safe Set backed by ConcurrentHashMap.
 */
public class BlacklistAccountRule extends AbstractFraudRule {

    public static final String RULE_NAME = "BLACKLIST_ACCOUNT_RULE";

    private final Set<String> blacklistedAccounts;
    private final Set<String> blacklistedIps;

    public BlacklistAccountRule() {
        super(RULE_NAME, "Checks recipient accounts and source IPs against global fraud sanctions list", 95);
        this.blacklistedAccounts = ConcurrentHashMap.newKeySet();
        this.blacklistedIps = ConcurrentHashMap.newKeySet();

        // Seed with standard test/known bad actors
        this.blacklistedAccounts.addAll(Arrays.asList(
                "ACC-SANCTIONED-999",
                "ACC-FRAUD-007",
                "ACC-SCAMMER-404",
                "ACC-BLOCKED-666"
        ));

        this.blacklistedIps.addAll(Arrays.asList(
                "198.51.100.99",
                "203.0.113.50",
                "10.99.99.99"
        ));
    }

    public void addBlacklistedAccount(String account) {
        if (account != null && !account.trim().isEmpty()) {
            this.blacklistedAccounts.add(account.trim().toUpperCase());
        }
    }

    public void addBlacklistedIp(String ip) {
        if (ip != null && !ip.trim().isEmpty()) {
            this.blacklistedIps.add(ip.trim());
        }
    }

    public boolean isAccountBlacklisted(String account) {
        if (account == null) return false;
        return this.blacklistedAccounts.contains(account.trim().toUpperCase());
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        String recipientAccount = transaction.getRecipientAccount();
        if (recipientAccount != null && blacklistedAccounts.contains(recipientAccount.trim().toUpperCase())) {
            return RuleEvaluation.criticalTrigger(
                    getRuleName(),
                    getDefaultWeight(),
                    String.format("CRITICAL: Recipient account '%s' is present on the anti-fraud sanctions blacklist", recipientAccount)
            );
        }

        String ip = transaction.getIpAddress();
        if (ip != null && blacklistedIps.contains(ip.trim())) {
            return RuleEvaluation.criticalTrigger(
                    getRuleName(),
                    getDefaultWeight(),
                    String.format("CRITICAL: Originating IP '%s' is identified as an active malicious botnet node", ip)
            );
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
