# To do

- Put some tests in for next game released (email text)
- Check lato is actually on in that email
- Test error emails are still being sent

Test to look at:

      it "should say what the next game to be released will be" do
        expect(page).to have_content("next game released will be Game 2")
      end
