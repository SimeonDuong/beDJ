package com.symplexum.beDJ;

import android.os.Bundle;
import android.widget.TextView;
import android.app.Activity;

public class ProfileActivity extends Activity {

	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        TextView textview = new TextView(this);
        textview.setText("This is the Profile tab");
        setContentView(textview);
    }


}
