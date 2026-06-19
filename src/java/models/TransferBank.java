package models;

import interfaces.Payable;
import java.util.ArrayList;

public class TransferBank extends Model<TransferBank> implements Payable {
    private int id;
    private String nama_bank;
    private String no_rekening;

    public TransferBank() {
        this.table = "transfer_bank";
        this.primaryKey = "id";
    }

    public TransferBank(String nama_bank, String no_rekening) {
        this();
        this.nama_bank = nama_bank;
        this.no_rekening = no_rekening;
    }

    @Override
    public boolean prosesBayar(double total) {
        return true;
    }

    public TransferBank getDetail(String nama_bank) {
        this.where("nama_bank = '" + nama_bank + "'");
        ArrayList<TransferBank> list = this.get();
        return list.isEmpty() ? null : list.get(0);
    }

    public String getNamaBank() { return nama_bank; }
    public String getNoRekening() { return no_rekening; }
}
