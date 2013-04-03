package com.symplexum.beDJ;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONObject;

import com.domain.beDJ.R;

import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.app.Activity;
import android.app.ListActivity;
import android.app.ProgressDialog;


public class LocationActivity extends ListActivity {


	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView selection;
        ListView listview = getListView();
        listview.setTextFilterEnabled(true);
        
    	String[] songnames = getResources().getStringArray(R.array.songnames_array);
    	setListAdapter(new ArrayAdapter<String>(this, R.layout.row, R.id.label, songnames));
        
        listview.setOnItemClickListener(new OnItemClickListener() {
        	
        public void onItemClick(AdapterView<?> parent, View view,
                int position, long id) {
            			getLocationTable();}
        
        });}
    
        public void getLocationTable(){
        	String result= "";
            
            try{
            JSONObject jObject = new JSONObject();
            jObject.put("username","questir5");
            jObject.put("password","Symplexum1!");
            jObject.put("id","2");
            StringEntity se= new StringEntity(jObject.toString());
   
		HttpClient httpclient = new DefaultHttpClient();
		HttpPost httppost = new HttpPost("http://questionforanswer.com/upvote.php");
		httppost.setEntity(se);
            		
		HttpResponse response = httpclient.execute(httppost);
		HttpEntity entity= response.getEntity();
		InputStream is = entity.getContent();
		
    BufferedReader reader = new BufferedReader(new InputStreamReader(is,"iso-8859-1"),8);
    StringBuilder sb = new StringBuilder();
    String line = null;
    
    while ((line = reader.readLine()) != null) {
            sb.append(line + "\n");
    }
    is.close();
    result=sb.toString();
    
}
catch(Exception e){
    Log.e("log_tag", "Error converting result "+e.toString());
}

// When clicked, show a toast with the TextView text
Toast.makeText(getApplicationContext(), (CharSequence) result, Toast.LENGTH_SHORT).show();

        }
	


}
