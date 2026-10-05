package com.fraudguard.fraud;

import com.fraudguard.model.Transaction;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Contextual metadata provided during transaction evaluation.
 * Encapsulates the user's recent transaction history, known devices,
 * and known network locations for anomaly detection.
 */
public class TransactionContext implements Serializable {

    private static final long serialVersionUID = 1L;

    private final List<Transaction> recentTransactions;
    private final Set<String> knownDevices;
    private final Set<String> knownLocations;
    private final Set<String> knownIps;

    public TransactionContext() {
        this.recentTransactions = new ArrayList<>();
        this.knownDevices = new HashSet<>();
        this.knownLocations = new HashSet<>();
        this.knownIps = new HashSet<>();
    }

    public TransactionContext(List<Transaction> recentTransactions,
                              Set<String> knownDevices,
                              Set<String> knownLocations,
                              Set<String> knownIps) {
        this.recentTransactions = recentTransactions != null ? new ArrayList<>(recentTransactions) : new ArrayList<>();
        this.knownDevices = knownDevices != null ? new HashSet<>(knownDevices) : new HashSet<>();
        this.knownLocations = knownLocations != null ? new HashSet<>(knownLocations) : new HashSet<>();
        this.knownIps = knownIps != null ? new HashSet<>(knownIps) : new HashSet<>();
    }

    public List<Transaction> getRecentTransactions() {
        return Collections.unmodifiableList(recentTransactions);
    }

    public Set<String> getKnownDevices() {
        return Collections.unmodifiableSet(knownDevices);
    }

    public Set<String> getKnownLocations() {
        return Collections.unmodifiableSet(knownLocations);
    }

    public Set<String> getKnownIps() {
        return Collections.unmodifiableSet(knownIps);
    }

    public void addRecentTransaction(Transaction tx) {
        if (tx != null) {
            this.recentTransactions.add(tx);
        }
    }

    public void addKnownDevice(String device) {
        if (device != null && !device.trim().isEmpty()) {
            this.knownDevices.add(device.trim());
        }
    }

    public void addKnownLocation(String location) {
        if (location != null && !location.trim().isEmpty()) {
            this.knownLocations.add(location.trim());
        }
    }

    public void addKnownIp(String ip) {
        if (ip != null && !ip.trim().isEmpty()) {
            this.knownIps.add(ip.trim());
        }
    }
}
