# To do

- Put some tests in for next game released (email text)
- Fix that deprecation warning on the pod admin tests
- Check lato is actually on in that email
- Test error emails are still being sent

Test to look at:

      it "should say what the next game to be released will be" do
        expect(page).to have_content("next game released will be Game 2")
      end


Before merging:

- Look through all the commits in this branch before merging
- Send the first batch only to hello@easypeasy and bsafwat@gmail and check before sending out for real
- So send out manually for the first week or two
