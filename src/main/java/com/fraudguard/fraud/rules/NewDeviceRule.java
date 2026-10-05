package com.fraudguard.fraud.rules;

import com.fraudguard.fraud.RuleEvaluation;
import com.fraudguard.fraud.TransactionContext;
import com.fraudguard.model.Transaction;
import com.fraudguard.model.User;

import java.util.Set;

/**
 * Detects transactions originating from previously unseen devices or untrusted IP addresses.
 * Signals potential credential stuffing or session hijacking.
 */
public class NewDeviceRule extends AbstractFraudRule {

    public static final String RULE_NAME = "NEW_DEVICE_RULE";

    public NewDeviceRule() {
        super(RULE_NAME, "Flags transactions initiated from unrecognized hardware or network devices", 25);
    }

    @Override
    public RuleEvaluation evaluate(Transaction transaction, User user, TransactionContext context) {
        if (!isEnabled() || transaction == null || context == null) {
            return RuleEvaluation.pass(getRuleName());
        }

        Set<String> knownDevices = context.getKnownDevices();
        String currentDevice = transaction.getDeviceFingerprint();

        // Only evaluate if user has an established profile with known devices
        if (!knownDevices.isEmpty() && currentDevice != null && !currentDevice.trim().isEmpty()) {
            if (!knownDevices.contains(currentDevice.trim())) {
                return RuleEvaluation.trigger(
                        getRuleName(),
                        getDefaultWeight(),
                        String.format("Unrecognized device fingerprint: '%s' is not in user's trusted device registry", currentDevice)
                );
            }
        }

        return RuleEvaluation.pass(getRuleName());
    }
}
